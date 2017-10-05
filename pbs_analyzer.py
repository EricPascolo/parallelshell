import sys
import json
import os
filecontained = ''

try:
    if os.path.isfile("pbsout.json"):
        filecontained = json.loads(open("pbsout.json").read())
    else:
        sys.exit()
except:
    pass

partofind = sys.argv[1]


nodesname_list = []

for i in filecontained["nodes"]:
    nodesname_list.append(i)

nodes_selected = []
for i in nodesname_list:
    strings = filecontained["nodes"][i]["resources_available"]["Qlist"].split(",")
    for n in strings:
        if  partofind ==  n:
            nodes_selected.append(i)


final_string = nodes_selected[0]

for i in nodes_selected[1:]:
    final_string = final_string+","+i

number_of_nodes_ok = "NODES FOUND = "+str(len(nodes_selected))+"\n"

sys.stderr.write(number_of_nodes_ok)
print final_string