#!/bin/sh

## TMMF: Switching on X11 forwarding might cause some latency issues. Use -C

export PATH=$HOME/.local/bin:${PATH}

if tmux ls; then
    tmux attach
else
    tmux new-session -d -s status
    tmux rename-window 'Monitor'
    tmux send-keys 'while true; do date; timeout 20s checkQuota 2>/dev/null > $HOME/.check_quota.dat; cat $HOME/.check_quota.dat; echo ""; sleep 1800; done' 'C-m'
    tmux split-window -v -t 0 -p 60
    tmux send-keys 'while true; do format=`echo "%.8i\ %.9P\ %.10j\ %.8u\ %.2t\ %.11M\ %.12l\ %.2C\ %8R\ %5Y"`; echo -e "\nhex:"; squeue -h -a -o "%.8i %.9P %.10j %.8u %.2t %.11M %.12l %.2C %8R %5Y" -p normal,interactive,jupyter,debug,idle | GREP_COLOR="01;32" grep --color=always -E "^.*$USER.* R .*|" | GREP_COLOR="01;33" grep --color=always -E "^.*$USER.* PD .*|" | GREP_COLOR="01;31" grep --color=always -E "^.*$USER.* S .*|" | GREP_COLOR="01;36" grep --color=always -E "^.*$USER.* CG .*|" | GREP_COLOR="00;30" grep --color=always -E "^|\(null\)|" ; echo; sleep 3; done' 'C-m'
    tmux split-window -h -p 100 -t 0
    tmux send-keys 'htop -d50' 'C-m'
    tmux split-window -h -p 47 -t 2
    tmux send-keys 'while true; do echo -e "\n\n\n\n\n\n"; format=`echo "%.5n\ \ %.9T\ \ %.10C\ \ %.8O\ \ %.6m\ \ %6E"`; sinfo -e -h -p normal -o "%.5n  %.9T  %.10C  %.8O  %.6m  %6E" -S n | GREP_COLOR="01;31" grep --color=always -E "^.* drain.*|^.* down.*|" | GREP_COLOR="01;33" grep --color=always -E "^.* compl.*|" | GREP_COLOR="01;32" grep --color=always -E "^.* idle.*|" | GREP_COLOR="01;30" grep --color=always -E "^.* alloc.*|"; sleep 15; done' 'C-m'
    tmux split-window -h -p 66 -t 3
    tmux send-keys 'while true; do DATE=`date +%m/%d -d "7days ago"`; echo -e "\n\n\n\n"; cmd="sacct -n --starttime $DATE --format User%6,JobID%8,jobname%12,ncpus%4,ReqMem%8,elapsed%12,state"; echo "hex:"; $cmd | grep $USER | grep -v "_interact" | GREP_COLOR="01;32" egrep --color=always "|RUNNING" | GREP_COLOR="01;31" egrep --color=always "|CANCELLED" | GREP_COLOR="01;31" egrep --color=always "|NODE_FAIL" | GREP_COLOR="01;36" egrep --color=always "|COMPLETED" | GREP_COLOR="01;31" egrep --color=always "|FAILED" | GREP_COLOR="01;33" egrep --color=always "|PENDING" | GREP_COLOR="01;33" egrep --color=always "|SUSPENDED" | GREP_COLOR="01;33" egrep --color=always "|TIMEOUT"; sleep 30; done' 'C-m'
    tmux -2 attach -t status
fi

