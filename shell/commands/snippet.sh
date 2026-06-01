# bash-only: zshrc also sources shell/commands, and bind -x is bash readline syntax.
if [ -n "$BASH_VERSION" ]; then

# Alt-s: fuzzy-pick a command from ~/dotfiles/shell/snippets and inject it into
# the prompt, parking the cursor on the first ^placeholder. Markers are a single
# ^ followed by an alphanumeric name (no closing delimiter), so one Alt-d
# (kill-word) wipes a whole ^name in a single keystroke.
__snippet_widget() {
    local file=~/dotfiles/shell/snippets
    [ -r "$file" ] || return 0
    command -v fzf >/dev/null 2>&1 || return 0

    local sel cmd before
    # Show only the description column; keep the whole line for parsing.
    sel=$(grep -vE '^\s*(#|$)' "$file" | \
        fzf --delimiter=' :: ' --with-nth=1 \
            --prompt='snippet> ' --height=40% --reverse \
            --preview 'echo {} | sed "s/^.* :: //"' --preview-window=down,3,wrap)
    [ -z "$sel" ] && return 0

    # Strip the "description :: " prefix to get the command.
    cmd="${sel#* :: }"

    READLINE_LINE="$cmd"
    # Cursor at the first ^placeholder, else end of line.
    if [[ "$cmd" == *'^'* ]]; then
        before="${cmd%%'^'*}"
        READLINE_POINT=${#before}
    else
        READLINE_POINT=${#cmd}
    fi
}

# Alt-i: jump to the next ^placeholder at or after the cursor and delete it,
# leaving the cursor where it was so you can type the value. Wraps to the start
# of the line if there are no placeholders ahead of the cursor.
__snippet_next() {
    local line="$READLINE_LINE" pt="$READLINE_POINT"
    local rest="${line:$pt}" base=$pt

    if [[ "$rest" != *'^'* ]]; then
        rest="$line"; base=0
        [[ "$rest" == *'^'* ]] || return 0   # no placeholders anywhere
    fi

    local before="${rest%%'^'*}"             # text before the marker
    local mstart=$(( base + ${#before} ))
    local body="${line:$((mstart+1))}"       # text after the ^
    local name="${body%%[!a-zA-Z0-9]*}"      # leading letters/digits = the name
    local mlen=$(( 1 + ${#name} ))           # ^ + name

    READLINE_LINE="${line:0:mstart}${line:$((mstart+mlen))}"
    READLINE_POINT=$mstart
}

bind -x '"\es": __snippet_widget'
bind -x '"\ei": __snippet_next'

fi
