
export nodes_knl=r113c15s01-hfi,r113c15s02-hfi,r113c15s03-hfi,r113c15s04-hfi,r113c16s01-hfi,r113c16s02-hfi,r113c16s03-hfi,r113c16s04-hfi,r113c17s01-hfi,r113c17s02-hfi,r113c17s03-hfi,r113c17s04-hfi,r113c18s01-hfi,r113c18s02-hfi,r114c15s01-hfi,r114c15s02-hfi,r114c15s03-hfi,r114c15s04-hfi,r114c16s01-hfi,r114c16s02-hfi,r114c16s03-hfi,r114c16s04-hfi,r114c17s01-hfi,r114c17s02-hfi,r114c17s03-hfi,r114c17s04-hfi,r114c18s01-hfi,r114c18s02-hfi

export nodes_skl=r149c12s01-hfi,r149c12s02-hfi,r149c12s03-hfi,r149c12s04-hfi,r149c13s01-hfi,r149c13s02-hfi,r149c13s03-hfi,r149c13s04-hfi

export nodes_bwd=r044c03s03,r044c03s04

export nodes_total="${nodes_knl},${nodes_bwd},${nodes_skl}"

#!/bin/bash
function pshell {

for i in $(echo $1 | tr ',' '\n'); do echo $i; ssh $i $2; done


}
