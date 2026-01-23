# https://derrick.blog/2022/12/21/command-timing-in-zsh/
# but I used date instead of gdate

preexec() {
    timer=$(($(date +%s%N)/1000000))
}

time_command() {
    if [[ -n "$timer" ]]; then
        now=$(($(date +%s%N)/1000000))
        elapsed=$((now - timer))

        reset_color='%f'
        RPROMPT="%F{cyan} $(converts "$elapsed") $reset_color"
        export RPROMPT
        unset timer
    else
        # reset if no command
        RPROMPT=""
    fi
}

converts() {
    local t=$1

    local d=$((t / 1000 / 60 / 60 / 24))
    local h=$((t / 1000 / 60 / 60 % 24))
    local m=$((t / 1000 / 60 % 60))
    local s=$((t / 1000 % 60))
    local ms=$((t % 1000))

    if [[ $s -lt 1 ]]; then
        return
    fi

    local result=""
    [[ $d -gt 0 ]] && result+=" ${d}d"
    [[ $h -gt 0 ]] && result+=" ${h}h"
    [[ $m -gt 0 ]] && result+=" ${m}m"
    [[ $s -gt 0 ]] && result+=" ${s}s"
    [[ $ms -gt 0 ]] && result+=" ${ms}ms"
    
    echo "$result"
}
