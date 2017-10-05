#marconi nodes
export nodes_knl=r113c15s01-hfi,r113c15s02-hfi,r113c15s03-hfi,r113c15s04-hfi,r113c16s01-hfi,r113c16s02-hfi,r113c16s03-hfi,r113c16s04-hfi,r113c17s01-hfi,r113c17s02-hfi,r113c17s03-hfi,r113c17s04-hfi,r113c18s01-hfi,r113c18s02-hfi,r114c15s01-hfi,r114c15s02-hfi,r114c15s03-hfi,r114c15s04-hfi,r114c16s01-hfi,r114c16s02-hfi,r114c16s03-hfi,r114c16s04-hfi,r114c17s01-hfi,r114c17s02-hfi,r114c17s03-hfi,r114c17s04-hfi,r114c18s01-hfi,r114c18s02-hfi

export nodes_skl=r149c12s01-hfi,r149c12s02-hfi,r149c12s03-hfi,r149c12s04-hfi,r149c13s01-hfi,r149c13s02-hfi,r149c13s03-hfi,r149c13s04-hfi
export nodes_bwd=r044c03s03,r044c03s04
export nodes_total="${nodes_knl},${nodes_bwd},${nodes_skl}"



#!/bin/bash
function pshell {
## interactive parallel shell
for i in $(echo $1 | tr ',' '\n'); do echo "-------------------------"$i; ssh $i "${2}"; done

}


function psub_shell {
## submitting parallel shell
remote_cmd=" ${3} nohup ${2}   < /dev/null > /dev/null 2>&1 &"
echo $remote_cmd
for i in $(echo $1 | tr ',' '\n'); do echo "-------------------------"$i; ssh $i $remote_cmd; done

}


function pbs_get_nodes_by_queue {
## return node list given queue name
## take two input argument:
##    - name of variable to store the nodelist
##    - name of queue
##

PSHELLDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd -P)
pbsnodes -a -Fjson > pbsout.json
export "$1"=$(python $PSHELLDIR/pbs_analyzer.py $2)
rm pbsout.json


}
