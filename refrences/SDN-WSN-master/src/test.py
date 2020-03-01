# test.py for BlinkToRadio Application

# The first thing we need to do is import TOSSIM
# and create a TOSSIM object 
from TOSSIM import *
import sys

# The first thing we need to do is import TOSSIM
# and create a TOSSIM object
t = Tossim([])
r = t.radio()

#create files to write output
logboot = open("logBoot.txt", "w")
logdiscovery = open("logDiscovery.txt", "w")
logapp = open("logApp.txt", "w")
lognode = open("logNode.txt", "w")
logrelay = open("logRelay.txt", "w")
logsink = open("logSink.txt", "w")
logperiodic = open("logPeriodic.txt", "w")
logperiodicsink = open("logPeriodicSink.txt", "w")
logack = open("logAck.txt", "w")
logdata = open("logData.txt", "w")
logsinkdata = open("logSinkData.txt", "w")

# open topology file and read
f = open("topo.txt", "r")
lines = f.readlines()
for line in lines:
  s = line.split()
  if (len(s) > 0):
    print " ", s[0], " ", s[1], " ", s[2];
    r.add(int(s[0]), int(s[1]), float(s[2]))


# We want to send the BlinkC and Boot channel to
# standard output. To do this, we need to import 
# the sys Pyhton package, which lets us refer to 
# standard output.
t.addChannel("WSNSDNTest", sys.stdout)
t.addChannel("Discovery", sys.stdout)
t.addChannel("Boot", sys.stdout)
t.addChannel("Neighbors", sys.stdout)
t.addChannel("Relay", sys.stdout)
t.addChannel("Sink", sys.stdout)
t.addChannel("Periodic", sys.stdout)
t.addChannel("PeriodicSink", sys.stdout)
t.addChannel("Ack", sys.stdout)
t.addChannel("Data", sys.stdout)
t.addChannel("SinkData", sys.stdout)
t.addChannel("WSNSDNTest", logapp)
t.addChannel("Boot", logboot)
t.addChannel("Discovery", logdiscovery)
t.addChannel("Neighbors", lognode)
t.addChannel("Relay", logrelay)
t.addChannel("Sink", logsink)
t.addChannel("Periodic", logperiodic)
t.addChannel("PeriodicSink", logperiodicsink)
t.addChannel("Ack", logack)
t.addChannel("Data", logdata)
t.addChannel("SinkData", logsinkdata)


# Create noise model
#noise = open("meyer-heavy.txt", "r")
noise = open("casino-lab.txt", "r")
lines = noise.readlines()
for line in lines:
  str = line.strip()
  if (str != ""):
    val = int(str)
    for i in range(0, 11):#####################49-node: 50###7node: 11
      t.getNode(i).addNoiseTraceReading(val)

for i in range(0, 11):#########################49-node: 50##7-node: 11
  print "Creating noise model for ",i;
  t.getNode(i).createNoiseModel()

# Booting nodes
t.getNode(0).bootAtTime(10);
t.getNode(1).bootAtTime(10);
t.getNode(2).bootAtTime(10);
#t.getNode(3).bootAtTime(10);
t.getNode(4).bootAtTime(10);
#t.getNode(5).bootAtTime(10);
t.getNode(6).bootAtTime(10);
#t.getNode(7).bootAtTime(10);
t.getNode(8).bootAtTime(10);
#t.getNode(9).bootAtTime(10);
t.getNode(10).bootAtTime(10);

#for i in range(0,11):#########################49-node: 50##7-node: 11
#  t.getNode(i).bootAtTime(10);



#Injecting packets

from InitializationMsg import*

f = open("InitFile.txt", "r")
lines = f.readlines()
for line in lines:
  if (line != "\t\n"):
    s = line.split()
    a = int(s[0])
    b = int(s[1])
    c = int(s[2])
    d = int(s[3])
    e = int(s[4])
    print a, " ", b, " ", c, " ", d, " ", e;
    msg = InitializationMsg()
    msg.set_UX(b)
    msg.set_UY(c)
#    msg.set_DX(0)
#    msg.set_DY(0)
    msg.set_ReplenishmentRate(d)
    msg.set_Type(e)
    pkt = t.newPacket()
    pkt.setData(msg.data)
    pkt.setType(msg.get_amType())
    pkt.setDestination(a)
    pkt.deliver(a, t.time() + 100)
    #print "Delivering " + msg;


# runNextEvent returns the next event 
for i in range(0, 3000):####################7node: 3000 49node: 500000
  t.runNextEvent()












from RoutingMsg import*
from collections import namedtuple

#opening and introducing the Routing Table Entries
f = open("RoutingTable.txt", "r")
lines = f.readlines()

MAX_NODES = 11###########################49-node : 49 ####7-node: 11
MAX_NEIGHBORS = 10
Entry = [([([([0]) for x in range(4)]) for y in range(MAX_NEIGHBORS)]) for z in range(MAX_NODES)]
print Entry;



for line in lines:
  if (line != "\t\n"):
    s = line.split()
    a = int(s[0])
    b = int(s[1])
    c = int(s[2])
    d = int(s[3])
    print " ", a, " ", b, " ", c, " ", d;
    
    Entry[a][b][0] = 1
    Entry[a][b][1] = b
    Entry[a][b][2] = c
    Entry[a][b][3] = d

print Entry





#print Routing
for x in range(MAX_NODES):
   
   if (Entry[x][0][0] == 1):
     msg = RoutingMsg()
     msg.set_nodeid(x)
     for y in range(MAX_NEIGHBORS):
       if (Entry[x][y][0] == 1):
         msg.setElement_NeighborAction_Action(y, Entry[x][y][3])
         msg.setElement_NeighborAction_NeighborNode(y, Entry[x][y][2])
         msg.setElement_NeighborAction_USED(y, Entry[x][y][0])
   
   pkt = t.newPacket()
   pkt.setData(msg.data)
   pkt.setType(msg.get_amType())
   pkt.setDestination(x)
   pkt.deliver(x, t.time() + 10)
   print "Delivering", msg;





for i in range(0, 50000):################50000##########750000
  t.runNextEvent()


