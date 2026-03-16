#
# This is all contingent on either tmux or zellij being installed, as well as https://github.com/todotxt/todo.txt-cli

_create_todo_session() {
	# Create a new session named "Todo" in the home directory
	tmux new-session -d -s Todo -c ~/
	
	# Split vertically - creates top pane (33%) and bottom section (67%)
	tmux split-window -v -p 67 -t Todo
	
	# Select the bottom pane and split it horizontally into 3 equal parts
	tmux select-pane -t Todo:1.1
	tmux split-window -h -p 67 -t Todo
	tmux split-window -h -p 50 -t Todo
	
	# Now we have 4 panes. Set up the commands:
	# Pane 0 (top, 33%): focused shell
	tmux select-pane -t Todo:1.0
	
	# Pane 1 (bottom left): watch todo.sh
	tmux select-pane -t Todo:1.1
	tmux send-keys -t Todo:1.1 "watch -n 3.5 -t todo.sh" C-m
	
	# Pane 2 (bottom middle): watch todo.sh ls +proj
	tmux select-pane -t Todo:1.2
	tmux send-keys -t Todo:1.2 "watch -n 3.5 -t todo.sh ls +proj" C-m
	
	# Pane 3 (bottom right): watch todo.sh ls +ops
	tmux select-pane -t Todo:1.3
	tmux send-keys -t Todo:1.3 "watch -n 3.5 -t todo.sh ls +ops" C-m
	
	# Return focus to top pane
	tmux select-pane -t Todo:1.0
}

todo() {
	if [ -n "$TMUX" ]; then
		if [ "$(tmux display-message -p '#S' 2>/dev/null)" = "Todo" ]; then
			echo "You're already in the Todo session!"
			return
		fi

		tmux switch-client -t Todo 2>/dev/null || {
			_create_todo_session
			tmux switch-client -t Todo
		}

		return
	fi
	
	tmux attach-session -t Todo 2>/dev/null || {
		_create_todo_session
		tmux attach-session -t Todo
	}
}

ztodo() {
	zellij --layout todo
}

