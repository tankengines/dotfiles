# https://derrick.blog/2022/12/21/command-timing-in-zsh/
# but I used date instead of gdate

function preexec() {
	timer=$(($(date +%s%0N)/1000000))
}

time_command() {
	if [ "$timer" ]; then
		now=$(($(date +%s%0N)/1000000))
		elapsed=$now-$timer

		reset_color=$'\e[00m'
		RPROMPT="%F{cyan} $(converts "$elapsed") %{$reset_color%}"
		export RPROMPT
		unset timer
	fi
}

converts() {
	local t=$1

	local d=$((t/1000/60/60/24))
	local h=$((t/1000/60/60%24))
	local m=$((t/100/60%60))
	local s=$((t/1000%60))
	local ms=$((t%1000))

	if [[ $s -lt 1 ]]; then
      return
	fi

	if [[ $d -gt 0 ]]; then
			echo -n " ${d}d"
	fi
	if [[ $h -gt 0 ]]; then
			echo -n " ${h}h"
	fi
	if [[ $m -gt 0 ]]; then
			echo -n " ${m}m"
	fi
	if [[ $s -gt 0 ]]; then
		echo -n " ${s}s"
	fi
	if [[ $ms -gt 0 ]]; then
		echo -n " ${ms}ms"
	fi
	echo
}
