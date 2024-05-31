import nnpy
import struct
import ipaddress
from p4utils.utils.helper import load_topo
from p4utils.utils.sswitch_thrift_API import SimpleSwitchThriftAPI
from p4utils.utils.thrift_API import ThriftAPI
import mycontroller



class DigestController():
    available_bandwidth = {}
    def __init__(self, sw_name, thrift_port):
        
        self.sw_name = sw_name
        self.thrift_port = thrift_port
        self.controller = SimpleSwitchThriftAPI(self.thrift_port)
        #print(self.controller.client)
        self.counter = ThriftAPI(self.thrift_port, 'localhost', None)

    def recv_msg_digest(self, msg):
        topic, device_id, ctx_id, list_id, buffer_id, num = struct.unpack("<iQiiQi",
                                                                          msg[:32])
        # print num, len(msg)
        offset = 2
        msg = msg[32:]
        #print(msg)
        #s
        
        for sub_message in range(num):
            #srcip, dstip, sport, dport = struct.unpack("!IIHH", msg[0:offset])
            '''
            print("src ip:", str(ipaddress.IPv4Address(srcip)), "dst ip:", str(
                ipaddress.IPv4Address(dstip)), "src port ", sport, "dst port ", dport)
            '''
            print("----- data capture in one second -----")
            use = self.counter.counter_read('bytes_counter', 100)
            
            
            if use[1] != 0:
                reply = self.counter.counter_read('reply_counter', 200)
                #print("reply packet proportion:", "{:.2%}".format(reply[1]/use[1]))
                small = self.counter.counter_read('small_counter', 300)
                #print("small packet proportion:", "{:.2%}".format(small[1]/use[1]))
            
            print('s'+str(self.thrift_port-9089))
            out = [0, 0, 0, 0, 0]
            for i in range(1,5):
                out[i] = self.counter.counter_read('out_counter', i)
                #print("available bandwidth:", "{}MB/s".format(float((LINK_BANDWIDTH-out[i][0])/1000000)))
                #print("sw_name" + self.sw_name[1:] + '-' + str(i))
                if mycontroller.BANDWIDTH.get(self.sw_name[1:] + '-' + str(i)) != None:
                    self.available_bandwidth[self.sw_name[1:] + '-' + str(i)] = str(round(float((mycontroller.BANDWIDTH[self.sw_name[1:] + '-' + str(i)]*1000000-out[i][0])/1024/1024),2))
            
            #print(self.available_bandwidth.items())
            self.counter.counter_reset('bytes_counter')
            self.counter.counter_reset('reply_counter')
            self.counter.counter_reset('small_counter')
            self.counter.counter_reset('out_counter')
            msg = msg[offset:]

        self.controller.client.bm_learning_ack_buffer(
            ctx_id, list_id, buffer_id)

    def run_digest_loop(self):
        sub = nnpy.Socket(nnpy.AF_SP, nnpy.SUB)
        #print((self.controller.client.__dict__))
        notifications_socket = self.controller.client.bm_mgmt_get_info().notifications_socket
        #print("connecting to notification sub %s" % notifications_socket)
        
        sub.connect(notifications_socket)
        sub.setsockopt(nnpy.SUB, nnpy.SUB_SUBSCRIBE, '')
        
        while True:      
            msg = sub.recv()
            self.recv_msg_digest(msg)

  
def main():
    DigestController("s1").run_digest_loop()


if __name__ == "__main__":
    main()
