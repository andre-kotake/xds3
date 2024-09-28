# shellcheck disable=SC2154

# Args
event_id=${args[--event_id]:=0}
config_file=${args[--config]:=""}
daemon=${args[--daemon]:=0}

if [[ $event_id -eq 0 && -z $config_file ]]; then
	red_bold 'The "start" command requires --event_id or --config.'

	# shellcheck disable=SC2034
	long_usage=yes
	xds3_start_usage

	exit 1
fi

# Kill the current running xboxdrv
kill_current_instance

command=()

# Build the xboxdrv command as an array
if [[ $event_id -gt 0 ]]; then
	green "Starting xboxdrv for: $(blue /dev/input/event"$event_id")"
	get_battery_level "$event_id"

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
fi

# Use the configuration file
if [[ -n $config_file ]]; then
	green "Starting xboxdrv with configuration: $(blue "$config_file")"
	command=("--config" "$config_file")
fi

# Add --daemon and --detach conditionally
if [[ $daemon -eq 1 ]]; then
	command+=("--daemon")
	command+=("--detach")
else
	echo "Press Ctrl-C to quit."
fi

xboxdrv "${command[@]}"
