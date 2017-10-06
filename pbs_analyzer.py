## PARALLEL SHELL software
##
## author : eric pascolo
##

import sys
import json
import os
import argparse

def cl_parser():
    """
    Parsing command line pars with argparse module and return dictionary
    """
    
    parser = argparse.ArgumentParser(description = '''
    Python check suite to HPC Cluster''',
    formatter_class=argparse.RawTextHelpFormatter
    )

    parser.add_argument(   '--job', 
                            required = False,
                            help = 'Given job name return list of nodes')

    parser.add_argument(   '--queue', 
                            required = False,
                            help = 'Given queue name return list of nodes')  
    args = parser.parse_args()
    convdict = vars(args)
    newdict =   dict([(vkey, vdata) for vkey, vdata in convdict.iteritems() if(vdata) ])
    return newdict


# init empty var
nodesname_list = []
nodes_selected = []
filecontained = ''

#load arguments
args = cl_parser()

#load json file
try:
    if os.path.isfile("pbsout.json"):
        filecontained = json.loads(open("pbsout.json").read())
    else:
        sys.exit()
except:
    pass


#load nodes name
for i in filecontained["nodes"]:
    nodesname_list.append(i)


# search loop
for i in nodesname_list:

    # queue search
    if "queue" in args:
        strings = filecontained["nodes"][i]["resources_available"]["Qlist"].split(",")
        for n in strings:
            if  args["queue"] ==  n:
                nodes_selected.append(i)

    # job search
    elif "job" in args:

        try:
            jobs = filecontained["nodes"][i]["jobs"]
            for n in jobs:
                if  args["job"] ==  n:
                    nodes_selected.append(i)
        except:
            pass
        
# write founded nodes on stdout
if len(nodes_selected) > 0:
    final_string = nodes_selected[0]

    for i in nodes_selected[1:]:
        final_string = final_string+","+i

    number_of_nodes_ok = "NODES FOUND = "+str(len(nodes_selected))+"\n"

    sys.stderr.write(number_of_nodes_ok)
    print final_string


# write on std error if no nodes was found
else: 
    sys.stderr.write("ERROR : no nodes found\n")