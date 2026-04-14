#!/usr/bin/env bash

REFRESH_SECONDS=10
LOADING_TEXT="󱛅  Loading networks..."
NO_NETWORKS_TEXT="󱛅  No networks found (auto refreshes every ${REFRESH_SECONDS}s)"

get_wifi_list() {
	nmcli --fields "SECURITY,SSID" device wifi list --rescan yes \
		| sed 1d \
		| sed 's/  */ /g' \
		| sed -E "s/WPA*.?\S/ /g" \
		| sed "s/^--/ /g" \
		| sed "s/  //g" \
		| sed "/--/d" \
		| sed '/^[[:space:]]*$/d'
}

get_toggle() {
	local connected
	connected=$(nmcli -fields WIFI g)
	if [[ "$connected" =~ "enabled" ]]; then
		echo "󰖪  Disable Wi-Fi"
	elif [[ "$connected" =~ "disabled" ]]; then
		echo "󰖩  Enable Wi-Fi"
	fi
}

tmp_wifi_file=$(mktemp)
cleanup() {
	rm -f "$tmp_wifi_file"
}
trap cleanup EXIT

get_wifi_list >"$tmp_wifi_file" 2>/dev/null &
scan_pid=$!

while true; do
	toggle=$(get_toggle)

	if kill -0 "$scan_pid" 2>/dev/null; then
		wifi_list="$LOADING_TEXT"
	else
		wifi_list=$(cat "$tmp_wifi_file")
		if [ -z "$wifi_list" ]; then
			wifi_list="$NO_NETWORKS_TEXT"
		fi
		get_wifi_list >"$tmp_wifi_file" 2>/dev/null &
		scan_pid=$!
	fi

	# Use rofi to select wifi network. Timeout triggers automatic refresh.
	chosen_network=$(printf "%s\n%s\n" "$toggle" "$wifi_list" | awk 'NF && !seen[$0]++' | timeout "${REFRESH_SECONDS}s" rofi -dmenu -i -selected-row 1 -p "Wi-Fi SSID: ")
	rofi_status=$?

	if [ "$rofi_status" -eq 124 ]; then
		continue
	fi
	if [ "$rofi_status" -ne 0 ] || [ -z "$chosen_network" ]; then
		exit
	fi
	if [ "$chosen_network" = "$LOADING_TEXT" ] || [ "$chosen_network" = "$NO_NETWORKS_TEXT" ]; then
		continue
	fi

	break
done

# Get name of connection
chosen_id="${chosen_network#*  }"

if [ -z "$chosen_network" ]; then
	exit
elif [ "$chosen_network" = "󰖩  Enable Wi-Fi" ]; then
	nmcli radio wifi on
elif [ "$chosen_network" = "󰖪  Disable Wi-Fi" ]; then
	nmcli radio wifi off
else
	# Message to show when connection is activated successfully
  	success_message="You are now connected to the Wi-Fi network \"$chosen_id\"."
	# Get saved connections
	saved_connections=$(nmcli -g NAME connection)
	if [[ $(echo "$saved_connections" | grep -w "$chosen_id") = "$chosen_id" ]]; then
		nmcli connection up id "$chosen_id" | grep "successfully" && notify-send "Connection Established" "$success_message"
	else
		if [[ "$chosen_network" =~ "" ]]; then
			wifi_password=$(rofi -dmenu -password -p "Password: " )
			nmcli device wifi connect "$chosen_id" password "$wifi_password" | grep "successfully" && notify-send "Connection Established" "$success_message"
		else
			nmcli device wifi connect "$chosen_id" | grep "successfully" && notify-send "Connection Established" "$success_message"
		fi
    fi
fi
