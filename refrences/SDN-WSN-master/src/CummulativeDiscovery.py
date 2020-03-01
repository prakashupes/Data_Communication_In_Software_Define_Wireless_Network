f = open("CummulativeStats.txt", "r")
fcd = open("CummulativeDiscovery.txt", "w")

sent = 0;
received = 0;

lines = f.readlines()
for line in lines:
  if (line != "\t\n"):
    s = line.split()
    a = s[0]
    b = s[1]
    sent = sent + a;
    received = received + b

  print sent, " ", received;


sent = sent/30;
received = received/30;

print >> fcd, "Sent:", sent, "recevied:", received;
