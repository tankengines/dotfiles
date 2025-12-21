# This runs both df -h and df -ih on the supplied path;
# defaults to the current path if none is specified
dfa() {
	local lookup="${1:-.}"
	local space=$(df -h "$lookup")
	local inode=$(df -ih "$lookup")

	echo "$(echo "$space" | awk 'NR==2 {print $1}')"
	echo "===================="
	echo "Space: $(echo "$space" | awk 'NR==2 {print $3}')/$(echo "$space" | awk 'NR==2 {print $2}') ($(echo "$space" | awk 'NR==2 {print $5}'))"
	echo "Inodes: $(echo "$inode" | awk 'NR==2 {print $3}')/$(echo "$inode" | awk 'NR==2 {print $2}') ($(echo "$inode" | awk 'NR==2 {print $5}'))"
}
