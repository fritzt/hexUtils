#!/bin/bash

## SLURM options

# Time limit after which the job will be killed. The default time limit
# is 60 minutes. Specified as HH:MM:SS or D-HH:MM
#SBATCH --time=30-00:00

# number of CPUs to utilize (this job is one "task")
#SBATCH --cpus-per-task=24

# Memory per node. Job will crash if this limit is exceeded.
# Default is 1G per allocated core
#SBATCH --mem=60G

# hyperthreading issue
#SBATCH --hint=nomultithread

# number of nodes to utilize. Can be set to >1 for MPI jobs. Otherwise,
# leave this set to 1 to make sure all allocated CPUs are on the same node.
#SBATCH -N 1

# Partition (queue) for the job
# - "normal" has a time limit of 30 days. Per-user resource limits apply.
# - "debug" has a time limit of 1 hour, and low resource limits,
#   but will pre-empt other jobs (memory permitting).
# - "idle" has no time limit or per-user limit, but jobs can be stopped
# (requeued) by jobs in the normal or debug queues.
#SBATCH --partition=normal

# Send email when the job begins and ends
#xSBATCH --mail-user=user@domain
#xSBATCH --mail-type=START,END

#SBATCH -J jobName

# To submit the job, run:
#
#     sbatch <jobname.sh>
#
# Additional options or overrides can be specified on the command line, e.g.:
#
#     sbatch --partition=debug jobname.sh

exePath=
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
currDir=${PWD##*/}

# remove stack size limit
ulimit -s unlimited
export KMP_STACKSIZE=500000000

echo "Binary path: " $exePath
echo "Directory: " $currDir
echo "Running on " $OMP_NUM_THREADS " cores"
echo "Host computer: " `hostname`
echo "Initiation date and time: " `date +%c`

time ${exePath}

# Check for success
result=$?

# Report additional information if job was killed because of memory limit
#oom_check $result

exit $result;
