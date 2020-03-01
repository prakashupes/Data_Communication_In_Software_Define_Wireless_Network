f = open("logDiscovery.txt", "r")
fo = open("DiscoveryStats.txt", "w") 
fa = open("CummulativeStats.txt", "a")

sent = 0;
received = 0;

lines = f.readlines()
for line in lines:
  if (line != "\t\n"):
    s = line.split()
    a = s[0]
    b = s[1]
    c = s[2]
    d = s[3]
    e = s[4]

  print a, " ", b, " ", c, " ", d, " ", e;
  print int(c), " ", int(d), " ", int(e);
  
  sent = sent + int(d);
  received = received + int(e);    

  print >> fo, c, d, e;
  #fo.write("a\t")
  #fo.write("b\t")
  #fo.write("c\t")
  #fo.write("d\t")
  #fo.write("e\t")
    #fo.write('{0} {1} {2} {3} {4}\n'.format(a, b, c, d, e))

print >> fo, "sent:", sent, "recieved", received;
print >> fa, sent, received;
#fo.close()





