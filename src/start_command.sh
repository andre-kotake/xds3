# shellcheck disable=SC2154
event_id=${args[event_id]}

start_xboxdrv() {
	green "Iniciando xboxdrv para /dev/input/event${event_id}"

	xboxdrv \
		--evdev "/dev/input/event${event_id}" \
		--silent \
		--detach-kernel-driver \
		--mimic-xpad \
		--evdev-keymap BTN_START=Start,BTN_MODE=Guide,BTN_SELECT=Back,BTN_SOUTH=A,BTN_EAST=B,BTN_WEST=X,BTN_NORTH=Y,BTN_TL=LB,BTN_TR=RB,BTN_TL2=LT,BTN_TR2=RT,BTN_THUMBL=TL,BTN_THUMBR=TR,BTN_DPAD_UP=DU,BTN_DPAD_DOWN=DD,BTN_DPAD_LEFT=DL,BTN_DPAD_RIGHT=DR \
		--evdev-absmap ABS_X=X1,ABS_Y=Y1,ABS_RX=X2,ABS_RY=Y2,ABS_Z=LT,ABS_RZ=RT \
		--axismap -Y1=Y1,-Y2=Y2 \
		--calibration RT=0:127:255,LT=0:127:255
}

start_xboxdrv
