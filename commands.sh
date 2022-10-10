#!/usr/bin/env bash

CODE_IP=${CODE_IP:=0.0.0.0}
CODE_PORT=${CODE_PORT:=8080}
SNORT_GIT=${SNORT_GIT:=github.com/snort3}

trap 'trap " " SIGTERM; kill 0; wait' SIGINT SIGTERM

setup_folder() {
cat <<EOF >>~/snort3.code-workspace
{
	"folders": [
		{
			"path": "workspace"
		}
	],
	"settings": {
		"terminal.integrated.defaultProfile.linux": "bash",
		"workbench.colorTheme": "Default Dark+",
		"window.autoDetectColorScheme": true
	}
}
EOF
}

get_snort(){
	git clone https://${SNORT_GIT}/libdaq.git ~/workspace/libdaq
	git clone https://${SNORT_GIT}/snort3.git ~/workspace/snort3
	# git clone https://${SNORT_GIT}/snort3_extra.git ~/workspace/snort3_extra
}

check_wsl() {
	uname -r | grep 'WSL' &>/dev/null
	if [ $? == 0 ]; then
		echo "Detected Windows Subsystem for Linux"
		echo "Switching to Legacy Iptables for Docker Daemon"
		sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
		sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
	fi
}

start_dockerd() {
	echo "Starting the Docker Daemon"
	sudo dockerd 2>&1 &
}

start_vscode() {
	echo "VScode Server on http://${CODE_IP}:${CODE_PORT}"
	code-server --disable-telemetry --bind-addr ${CODE_IP}:${CODE_PORT} ~/snort3.code-workspace 2>&1 &
}

setup_folder
check_wsl
start_dockerd
start_vscode
get_snort

echo "================================================================"
echo "=======     Logon $(grep password: ~/.config/code-server/config.yaml)     ======="
echo "================================================================"

sleep infinity
