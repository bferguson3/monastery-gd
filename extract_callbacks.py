outstr = "\nenum item_callbacks { NONE, "
f = open("items.dat", "r")
inf = f.read()
f.close()
lines = inf.split('\n')
header = lines[0].split(',')	
i = 0
qf = 0
while i < len(header):
	if (header[i] == "CALLBACK"):
		qf = i 
		break
	i += 1
i = 1
while i < len(lines) - 1:
	items = lines[i].split(",")
	outstr += items[qf] + ", "
	i += 1 
items = lines[i].split(",")
outstr += items[qf]
outstr += " };\n"
#print(outstr)
f = open("item_callbacks.gd", "w")
f.write(outstr)
f.close()