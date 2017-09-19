#marconi nodes
export nodes_knl=r113c15s01-hfi,r113c15s02-hfi,r113c15s03-hfi,r113c15s04-hfi,r113c16s01-hfi,r113c16s02-hfi,r113c16s03-hfi,r113c16s04-hfi,r113c17s01-hfi,r113c17s02-hfi,r113c17s03-hfi,r113c17s04-hfi,r113c18s01-hfi,r113c18s02-hfi,r114c15s01-hfi,r114c15s02-hfi,r114c15s03-hfi,r114c15s04-hfi,r114c16s01-hfi,r114c16s02-hfi,r114c16s03-hfi,r114c16s04-hfi,r114c17s01-hfi,r114c17s02-hfi,r114c17s03-hfi,r114c17s04-hfi,r114c18s01-hfi,r114c18s02-hfi

export nodes_skl=r149c12s01-hfi,r149c12s02-hfi,r149c12s03-hfi,r149c12s04-hfi,r149c13s01-hfi,r149c13s02-hfi,r149c13s03-hfi,r149c13s04-hfi
export nodes_bwd=r044c03s03,r044c03s04
export nodes_total="${nodes_knl},${nodes_bwd},${nodes_skl}"



#!/bin/bash
function pshell {

for i in $(echo $1 | tr ',' '\n'); do echo $i; ssh $i "${2}"; done

}


function psub_shell {

remote_cmd="nohup ${2}  < /dev/null > /dev/null 2&>1 &"
echo $remote_cmd
for i in $(echo $1 | tr ',' '\n'); do echo $i; ssh $i $remote_cmd; done

}


function get_nodes_by_queue {

pbsnodes -a -Fjson > pbsout.json
python -<< EOF "$1"

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
print filecontained["nodes"]

EOF

rm pbsout.json

#nodes_array=($(pbsnodes -a | grep -a12 $1 | grep  -E '((r[0-9]{1,}c[0-9]{1,}s[0-9]{1,}(-hfi)?))\n'))
#export nodes=${nodes_array[0]}
#for x in ${nodes_array[@]:1}; do nodes=$nodes,$x; done;

}
