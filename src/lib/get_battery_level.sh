get_battery_level() {
	local event_id="$1"
	local mac_address
	local capacity

	mac_address=$(
		</proc/bus/input/devices awk -v handler="event${event_id}" \
			'/H: Handlers=/{if ($0 ~ handler) print prev} {prev=$0}' |
			awk -F'=' '/U: Uniq=/{print $2}' | tr '[:upper:]' '[:lower:]'
	)
	capacity=$(cat "/sys/class/power_supply/sony_controller_battery_${mac_address}/capacity")

	echo "Battery: $(green "${capacity}%")"
}
