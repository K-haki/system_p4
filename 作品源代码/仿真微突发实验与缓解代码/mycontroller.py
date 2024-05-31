#!/usr/bin/env python2
import argparse
import grpc
import os
import sys
import copy
import digest_controller
import _thread
import threading
from threading import Thread
from time import sleep
from p4utils.utils.sswitch_thrift_API import SimpleSwitchThriftAPI
from p4utils.utils.helper import load_topo
from p4utils.utils.sswitch_p4runtime_API import SimpleSwitchP4RuntimeAPI
import networkx as nx
import nnpy
import struct
import subprocess
from scapy.all import Ether, sniff, Packet, BitField, raw


# Import P4Runtime lib from parent utils dir
# Probably there's a better way of doing this.
sys.path.append(
    os.path.join(os.path.dirname(os.path.abspath(__file__)),
                 '../../utils/'))
import p4runtime_lib.bmv2
from p4runtime_lib.error_utils import printGrpcError
from p4runtime_lib.switch import ShutdownAllSwitchConnections
import p4runtime_lib.helper

SWITCH_TO_HOST_PORT = 1
SWITCH_TO_SWITCH_PORT = 2
ECMP_BASE = 1
ECMP_MAX = 10
# BANDWIDTH = {"1-2": 3.75, "1-3": 2.5, "2-3": 1.25, "2-4": 2.5, "3-4": 3.75, "2-1": 3.75, "3-1": 2.5, "3-2": 1.25, "4-2": 2.5, "4-3": 3.75}

controllers = []
s = [1,1,2,2,3]
t = [2,3,3,4,4]
ip_address = {"10.0.0.1": 1, "10.0.0.2": 4}


nodes = 4

switches = [0]
digest_controllers = []

def writeDesignateRules(controller, dst_ip_addr, netmask, out_port,
                        ):

        #print("Installed Designated dstAddr rule on %s" % controller)


    controller.table_add(
    "MyIngress.ecmp_group",
    "MyIngress.set_designate_nhop",
    [dst_ip_addr + "/" + str(netmask), "1"],
    [str(out_port)])


    return True




def write_select_forwardRules2(controller, dstIP, port, ):

    controller.table_add(
        "MyIngress.select_forward_exact",
        "MyIngress.ipv4_select_forward",
        [str(dstIP)],
        [str(port)])
    #print(dstIP, str(nhop[0][0]), str(nhop[1][0]), str(nhop[0][1]*10))

def p4tables(controller, source, target, netmask, paths, ):

    for path in paths.keys():
        for key,value in paths[path].items():
             # trans from s1 to h1
            print("path", path)
            if path == ip_address[source]:
                writeDesignateRules(controller[path], source, 32, path)

            if path == ip_address[target]:
                writeDesignateRules(controller[path], target, 32, path )

            # trans from s4 to h2
            if value is None:
                writeDesignateRules(controller[path], target, 32, key )
                break

            # special situation

            if float(value) == 1.0:
                writeDesignateRules(controller[path], target, 32, key)
                break

            if float(value) == 0.0:
                continue

            list1 = [list(row) for row in paths[path].items()]
       #     #print("list.items:", list1, "list[0][0]:", list1[0][0], "list[0][1]*10:", list1[0][1] * 10, "list[1][0]:", list1[1][0])
            #print(target, list1)
            write_select_forwardRules2(controller[path], target, list1)
            break



#generate simple paths from source to target
def createAllSimplePaths(source, target, cutoff=None):


    G = nx.Graph()
    for i in range(0,len(s)):
        G.add_edge(s[i],t[i])
    paths = nx.all_simple_paths(G, source=source, target=target, cutoff=cutoff)
    #for path in paths:
    #    print(path)

    return list(paths)


def entryConstraints(nodes, add_entry):
    #nodes [[1,2,3],[1,4,3]]
    #add_entry [[0,1,2], [0,1,3] <--> [s1+0,s2+1,s3+2], [s1+0,s4+1,s3+3]
    #print(nodes, add_entry)
    i_list = []


    for i in range(len(nodes)):
        for j in range(len(nodes[i])):

            controller = SimpleSwitchThriftAPI(9089+int(nodes[i][j]))
            controllers.insert(nodes[i][j]-1 , controller)
            tables = controller.get_tables()

            sum = 0
            for key in tables.keys():
                sum += controller.table_num_entries(key)
            if sum + add_entry[i][j] > 1024:
                i_list.append(i)
                break

    for a in range(len(i_list)):
        del nodes[len(i_list)-a-1]
    return nodes

'''

    interval Maxhop-Minhop
    maxhop maxhop
'''
def createAllSimplePaths(source, target, interval=-1, maxhop=-1):


    G = nx.Graph()

    for i in range(0,len(s)):
        G.add_edge(s[i],t[i])

    if interval < 0:
        cutoff = None
    else:
        cutoff = maxMinConstraint(G, source, target, interval)

    #Maxhop Constraint
    if maxhop > 0 and (cutoff != None):
        cutoff = min(cutoff, maxhop)
    else:
        cutoff = maxhop

    paths = nx.all_simple_paths(G, source=source, target=target, cutoff=cutoff)


    return list(paths)

#Constraint: maxhop - minhop <= interval
def maxMinConstraint(G, source, target, interval):

    shortest = nx.bidirectional_dijkstra(G, source, target)[0]
    return shortest+interval

#removeLoop in route_list
def removeLoop(path_list):
    node_relation = list_to_relation(path_list)
    root = str(path_list[0][0])


    node_dic = {}
    have_kid = []
    have_exist = []
    node_list = []

    for key in node_relation:
        chunk = key.split("->")
        if not chunk[0] in have_kid:
            have_kid.append(chunk[0])

        if not chunk[0] in node_dic.keys():
            node_dic[chunk[0]] = []
            node_dic[chunk[0]].append(chunk[1])
        else:
            node_dic[chunk[0]].append(chunk[1])
    node_list.append(root)
    extra = []
    while len(node_list) != 0:
        rmtmp = []

        if not node_list[0] in have_kid:
            node_list.remove(node_list[0])
        else:
            for key in node_dic[node_list[0]]:
                node_list.append(key)
                if key in have_exist:
                    rmtmp.append(key)
            if node_list[0] not in have_exist:
                have_exist.append(node_list[0])
            for keyy in rmtmp:
                if (node_list[0], keyy) in extra:
                    continue
                else:
                    node_dic[node_list[0]].remove(keyy)
                    extra.append((keyy, node_list[0]))

            node_list.remove(node_list[0])
    #print("node",node_dic)
    return node_dic


#include removeLoop constraints
def constructDAG(paths):
    dicts = removeLoop(paths)
    #print("dicts", dicts)
    G = nx.DiGraph()

    for key in dicts.keys():
        for i in range(len(dicts[key])):
            G.add_edge(int(key),int(dicts[key][i]))
    return G

#set links capacity in G
def setLinkCapacity(G, capacity):
    for key in capacity.keys():
        src,dst = key.split("-")
        G.edges[int(src),int(dst)]["capacity"]=round(float(capacity[key]),2)


#set all links capacity to 'bandwidth'
def setLinkCapacityAll(G, bandwidth):
    for tup in G.edges:
        G.edges[tup[0],tup[1]]["capacity"]=bandwidth

#update link Capacity in G , capacity = current_detect + last_loop_capacity
def updateLinkCapacity(G, detect):
    #for tup in G.edges:
    #    G.edges[tup[0],tup[1]]["capacity"]=detect[str(tup[0]) + '-' + str(tup[1])]
    setLinkCapacity(G,detect)

    #
    #for key in history.keys():
    #    src,dst = key.split("-")
    #    G.edges[src,dst]["capacity"] += (history[key] - detect[key])

    return G

#{'1':'3':2,'4':2} --> {'1':"3':0.5, '4':0.5}
def generateProbability(flow_dict):
    for key in flow_dict.keys():
        sum = 0
        for value in flow_dict[key]:
            sum += flow_dict[key][value]
        for value in flow_dict[key]:
            flow_dict[key][value] = round(float(flow_dict[key][value]/sum),2)
    return flow_dict


#format conversion
def list_to_relation(path_list):
    node_relation = []
    for list in path_list:
        for i in range(len(list)-1):
            tempRelation = str(list[i]) + '->' + str(list[i+1])
           # print(tempRelation)
            if tempRelation not in node_relation:
                node_relation.append(tempRelation)
    return  node_relation

def calculateMutation(src_ip, dst_ip, interval, max_hop):
    # 1. construct undirected graph and add constriants
        paths = createAllSimplePaths(ip_address[src_ip], ip_address[dst_ip], interval, max_hop)


        # 2. construct DAG
        G = constructDAG(paths)


        # 3. get real-time link available_bandwidth
        detect = {}
        print("available:", digest_controllers[0].available_bandwidth)
        if len(digest_controllers[0].available_bandwidth) != 0:
            for src, dst in G.edges:
                detect[str(src) + '-' + str(dst)] = digest_controllers[0].available_bandwidth[str(src) + '-' + str(dst)]
        else:
            for src, dst in G.edges:
                detect[str(src) + '-' + str(dst)] = str(BANDWIDTH[str(src) + '-' + str(dst)])
        #print("detect:",detect)


        # 4. adjust capacity
        G = updateLinkCapacity(G, detect)


        flow_value, flow_dict = nx.maximum_flow(G, ip_address[src_ip], ip_address[dst_ip])



        flow_dict_pro = generateProbability(copy.deepcopy(flow_dict))
        print(flow_dict)
        print(flow_dict_pro)

        return flow_dict_pro
# def connect_to_switches():
#     topo = load_topo('topology.json')
#     for p4rtswitch, data in topo.get_p4switches().items():#it the same ability without the items()functin
#         device_id = topo.get_p4switch_id(p4rtswitch)
#         grpc_port = topo.get_grpc_port(p4rtswitch)
#         p4rt_path = data['p4rt_path']
#         json_path = data['json_path']
#         sw_data = topo.get_p4rtswitches()[p4rtswitch]
#         cpu_port = topo.get_cpu_port_index(p4rtswitch)
#         switches[1] = SimpleSwitchP4RuntimeAPI(device_id, grpc_port,
#                                                                         p4rt_path=p4rt_path,
#                                                                         json_path=json_path)
#
#
# def config_digest():
#         # Up to 10 digests can be sent in a single message. Max timeout set to 1 ms.
#     connect_to_switches()
#     switches[1].digest_enable('micbudata_t', 1000000, 1, 1000000)
#
# def run_digest_loop():
#     print("begin to receive")
#     config_digest()
#     while True:
#         dig_list = switches[1].get_digest_list()
#         unpack_digest(dig_list)
#
# def unpack_digest(dig_list):
#
#         # rate = [0,0,0,0,0,0,0]
#         # dstAddr = 0
#         # print(dig_list.data)
#     for dig in dig_list.data:
#             # rate =[0,0,0,0,0,0]
#             # print(dstAddr)
#             # if dstAddr == '0xa000003' :
#             #     getrate = int.from_bytes(dig.struct.members[0].bitstring, byteorder='big')
#             #     print(getrate)
#         for i in range(6 ):
#             getrate = int.from_bytes(dig.struct.members[i].bitstring, byteorder='big')
#                 # I know which problem it will add the last num to the deque
#             print(getrate,i)
#



def main():
    # Instantiate a P4Runtime helper from the p4info file


    for i in range(1, nodes+1):
        switches.append(SimpleSwitchThriftAPI(9089+i))

    # run_digest_loop()


    #topo = load_topo('topology.json')



    # for i in range(0, nodes):
    #     digest_controllers.append(digest_controller.DigestController("s{}".format(i + 1), 9090 + i))
    #     threading.Thread(target = digest_controllers[i].run_digest_loop).start()




    src_ip_h1 = "10.0.0.1"
    src_ip_h2 = "10.0.0.2"
    dst_ip1 = "10.0.0.3"
    dst_ip2 = "10.0.0.4"

    writeDesignateRules(switches[1], src_ip_h1, 32, 1)
    writeDesignateRules(switches[1], src_ip_h2, 32, 5)

    writeDesignateRules(switches[4], dst_ip1, 32, 4)
    writeDesignateRules(switches[4], dst_ip2, 32, 5)

    write_select_forwardRules2(switches[1], dst_ip1, 2)
    write_select_forwardRules2(switches[2], dst_ip1, 4)

    write_select_forwardRules2(switches[1], dst_ip2, 4)


    write_select_forwardRules2(switches[2], src_ip_h1, 1)
    # write_select_forwardRules2(switches[2], src_ip_h2, 1)

    write_select_forwardRules2(switches[3], dst_ip1, 4)
    # write_select_forwardRules2(switches[3], dst_ip2, 4)

    write_select_forwardRules2(switches[3], src_ip_h1, 1)
    # write_select_forwardRules2(switches[3], src_ip_h2, 1)
    write_select_forwardRules2(switches[4], src_ip_h1, 2)

    write_select_forwardRules2(switches[4], src_ip_h2, 1)











if __name__ == '__main__':
    main()
