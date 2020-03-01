MAX_NODES = 11
MAX_NEIGHBORS = 10
Neighbor = ['No', 'Neighbor', 'Action']
NeighborList = [Neighbor for i in range(MAX_NEIGHBORS)]
Entry = ['No', 'Node', NeighborList]
Routing = [Entry for y in range(MAX_NODES)]

for a in range(MAX_NODES):
  Routing[a][0] = a
  Routing[a][1] = a*2
  print a
  for b in range(MAX_NEIGHBORS):
    print "\t\t", b, "\t", Routing[a][2][b][0], "\n";
  for c in range(MAX_NEIGHBORS):
    Routing[a][2][c][0] = c
    print "\t\t", c, "\t", Routing[a][2][c][0], "\n";

for d in range(MAX_NODES):
  for e in range(MAX_NEIGHBORS):
    print "\t\t", 

print Routing;







MAX_NODES = 11
MAX_NEIGHBORS = 10
Neighbor = ['No', 'Neighbor', 'Action']
NeighborList = [Neighbor for i in range(MAX_NEIGHBORS)]
Entry = ['No', 'Node', NeighborList]
Routing = [Entry for y in range(MAX_NODES)]

for a in range(MAX_NODES):
  Routing[a][0] = a
  Routing[a][1] = a*2

  for c in range(MAX_NEIGHBORS):
    Routing[a][2][c][0] = c
    print "\t\t", c, "\t", Routing[a][2][c][0], "\n";

print Routing;


print Routing;
