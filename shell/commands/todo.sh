#!/bin/zsh
#
# This is all contingent on either tmux or zellij being installed, as well as https://github.com/todotxt/todo.txt-cli

todo() {
	tmux attach-session -t Todo 2>/dev/null || {
		# Create a new session named "Todo" in ~ directory
		tmux new-session -d -s Todo -c ~
		
		# Split vertically - creates top pane (33%) and bottom section (67%)
		tmux split-window -v -p 67
		
		# Select the bottom pane and split it horizontally into 3 equal parts
		tmux select-pane -t 1
		tmux split-window -h -p 67
		tmux split-window -h -p 50
		
		# Now we have 4 panes. Set up the commands:
		# Pane 0 (top, 33%): focused shell
		tmux select-pane -t 0
		
		# Pane 1 (bottom left): watch todo.sh ls +proj
		tmux select-pane -t 1
		tmux send-keys "watch -n 3.5 -t todo.sh" C-m
		
		# Pane 2 (bottom middle): watch todo.sh ls
		tmux select-pane -t 2
		tmux send-keys "watch -n 3.5 -t todo.sh ls" C-m
		
		# Pane 3 (bottom right): watch todo.sh ls +ops
		tmux select-pane -t 3
		tmux send-keys "watch -n 3.5 -t todo.sh ls +ops" C-m
		
		# Return focus to top pane
		tmux select-pane -t 0
		
		# Attach to the session
		tmux attach-session -t Todo
	}
}

ztodo() {
	zellij --layout todo
}

