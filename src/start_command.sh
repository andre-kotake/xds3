# shellcheck disable=SC2154
event_id=${args[event_id]}
daemon=${args[--daemon]:=0}

get_battery_level() {
	local mac_address
	mac_address=$(
		</proc/bus/input/devices awk -v handler="event${event_id}" \
			'/H: Handlers=/{if ($0 ~ handler) print prev} {prev=$0}' |
			awk -F'=' '/U: Uniq=/{print $2}' | tr '[:upper:]' '[:lower:]'
	)

	echo "Battery: $(cat "/sys/class/power_supply/sony_controller_battery_${mac_address}/capacity")%"
}

start_xboxdrv() {
	green "Starting xboxdrv for: /dev/input/event${event_id}"

	# Kill active xboxdrv
	{
		set +e # dont exit on error
		killall xboxdrv --wait --interactive
		set -e
	} 2>&1

	# Show battery
	get_battery_level

	# Build the xboxdrv command as an array
	command=(
		"--evdev" "/dev/input/event${event_id}"
		"--evdev-keymap" "BTN_START=Start,BTN_MODE=Guide,BTN_SELECT=Back,BTN_SOUTH=A,BTN_EAST=B,BTN_WEST=X,BTN_NORTH=Y,BTN_TL=LB,BTN_TR=RB,BTN_TL2=LT,BTN_TR2=RT,BTN_THUMBL=TL,BTN_THUMBR=TR,BTN_DPAD_UP=DU,BTN_DPAD_DOWN=DD,BTN_DPAD_LEFT=DL,BTN_DPAD_RIGHT=DR"
		"--evdev-absmap" "ABS_X=X1,ABS_Y=Y1,ABS_RX=X2,ABS_RY=Y2,ABS_Z=LT,ABS_RZ=RT"
		"--axismap" "-Y1=Y1,-Y2=Y2"
		"--calibration" "RT=0:127:255,LT=0:127:255"
		"--mimic-xpad"
		"--detach-kernel-driver"
		"--quiet"
		"--silent"
	)

	# Add --daemon and --detach conditionally
	if [[ $daemon -eq 1 ]]; then
		command+=("--daemon")
		command+=("--detach")
	else
		echo "Press Ctrl-C to quit."
	fi

	xboxdrv "${command[@]}"
}

start_xboxdrv
