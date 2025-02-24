SLEEP_TIME=2
function log() {
	echo -e "\e[33m:: $1\e[0m"
}
function handle_error() {
	log "Error: $1"
	exit 1
}

