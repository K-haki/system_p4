from tkinter import NE
from p4utils.mininetlib.network_API import NetworkAPI
from p4utils.mininetlib.cli import P4CLI
from p4utils.utils.helper import load_topo
import threading

#def setMAC():
#    #net is initialized after startNetwork()
#    cli = P4CLI(net)
#    cli.getNode('h1').setMAC("00:00:00:00:00:01")
#   print(cli.getNode('h2').setMAC("00:00:00:00:00:02"))

#topo = load_topo('topology.json')
net = NetworkAPI()


N_SWITCHS = 4
N_NODES = 4


for i in range(N_SWITCHS):
    net.addP4Switch('s{}'.format(i + 1))

for i in range(N_NODES):
    net.addHost('h{}'.format(i + 1))
net.setP4SourceAll("load_balance.p4")

# net.setP4SourceAll("load_balance_random.p4")
# net.addP4RuntimeSwitch('s1')

net.addLink('h1', 's1', port2=1, bw="100",loss=0.05)
net.addLink('h2', 's1', port2=5, bw="100",loss=0.05)

net.addLink('h3', 's4', port2=4, bw="100",loss=0.05)
net.addLink('h4', 's4', port2=5, bw="100",loss=0.05)


net.addLink('s1', 's2', port1=2, port2=1,bw="50")
net.addLink('s1', 's3', port1=3, port2=1,bw="150",loss=5)
net.addLink('s1', 's4', port1=4, port2=1,bw="200",loss=3)
net.addLink('s2', 's4', port1=4, port2=2,bw="200")
net.addLink('s3', 's4', port1=4, port2=3,bw="200")

#for i in range(N_NODES):
#    net.setDefaultRoute('h{}'.format(i + 1), "10.0.{}.{}/24".format(i + 1, i * 10))

#net.setIntfMac("h1", "s1", "00:00:00:00:00:01")
net.enableCpuPortAll()



#net.l2()


net.setBwAll(100)
#net.enableLogAll()
net.enableGwArp()
net.enableCli()

#t = threading.Timer(8.0, setMAC)
#t.start()
net.startNetwork()




#net.execScript("py h1.setMAC('00:00:00:00:00:01')")
#net.execScript("py h2.setMAC('00:00:00:00:00:02')")
