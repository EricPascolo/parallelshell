#!/bin/bash

## PARALLEL SHELL software and scheduler utilities
##
## author : eric pascolo
##

#############################################################################SSH
export PSHELLDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd -P)
echo "PSHELL LOADED FROM " $PSHELLDIR

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

#############################################################################PBS

function pbs_get_nodes_by_queue {
## return node list given queue name
## take two input argument:
##    - name of variable to store the nodelist
##    - name of queue
##
if [ $# -eq 3 ];then
  pbsnodes -a -Fjson -s $3 > pbsout.json
else
  pbsnodes -a -Fjson > pbsout.json
fi

export "$1"=$(python $PSHELLDIR/pbs_analyzer.py --queue $2)
rm pbsout.json

}


function pbs_get_nodes_by_job {
## return node list given job name
## take two input argument:
##    - name of variable to store the nodelist
##    - name of job
##
if [ $# -eq 3 ];then
  pbsnodes -a -Fjson -s $3 > pbsout.json
else
  pbsnodes -a -Fjson > pbsout.json
fi

export "$1"=$(python $PSHELLDIR/pbs_analyzer.py --job $2)
rm pbsout.json

}

###########################################################################SLURM

function srun_submit_command_on_multiple_allocated_nodes {
# submit in slurm nodes allocated the same command
# The subjob is the same for each node.
# Take one arg:
#     - command to submit to each node
#
echo 'Running multi run test'
myhostnames=$(scontrol show hostname)
export myhostnames=$(echo $myhostnames)
date
for node in $myhostnames
do
  date
  echo 'Submitting job for node '$node
  echo "1srun -w $node $1 &"
done
date
echo 'Waiting for job to finish'
wait
echo 'Jobs finished'
date

}

function slurm_get_nodes_names {
## return list of reserved nodes in current slurm job
## the difference with $SLURM_JOB_NODELIST environment
## variable is that the node names are not grouped
## $SLURM_JOB_NODELIST -> r06c01s[1,2]
## slurm_get_nodes_names -> r06c01s01,r06c01s02
## take one input argument:
##    - name of variable to store the nodelist
##
myhostnames=$(scontrol show hostname)
export "$1"=$(echo $myhostnames | tr ' ' ',')

}
