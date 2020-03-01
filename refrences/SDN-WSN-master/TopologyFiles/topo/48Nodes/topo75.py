f = open("topo.txt", "r")

lines = f.readlines()
for line in lines:
  if (line != "\t\n"):
    s = line.split()
    a = s[0]
    b = s[1]
    c = s[2]
    print a,"", b, '-75.0';
