kill_current_instance() {
	set +e # dont exit on error

	if [[ -n "$(pgrep xboxdrv)" ]]; then
		echo "Stopping current instance of $(blue "xboxdrv")..."
		killall xboxdrv --wait
		echo "Stopped $(blue "xboxdrv")"
		echo
	fi

	set -e # exit on error again
}
