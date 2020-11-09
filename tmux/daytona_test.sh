#!/bin/sh
tmux has-session -t daytona_test
if [ $? != 0 ]; then
tmux new -s daytona_test -n console -d
fi
tmux new-window -t daytona_test -n $1
tmux split-window -h -t daytona_test 
tmux split-window -v -t daytona_test:.2 
tmux select-layout -t daytona_test main-vertical
tmux select-pane -t daytona_test:.1
tmux resize-pane -R -t daytona_test:.1 40
tmux send-keys -t daytona_test:.1 "ssh -A $1" C-m
tmux send-keys -t daytona_test:.2 "ssh -A $1" C-m
tmux send-keys -t daytona_test:.3 "ssh -At $1 'sudo less /var/log/messages'" C-m

if [ "$TMUX" == "" ]; then
tmux attach -t daytona_test
fi
