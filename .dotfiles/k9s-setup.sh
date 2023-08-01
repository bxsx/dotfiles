#!/bin/bash

set -eo pipefail

if [[ "${OSTYPE}" == "darwin"* ]]; then
	config_dest="${HOME}/Library/Application Support/k9s"
elif [[ "${OSTYPE}" == "linux"* ]]; then
	if [[ -n "${XDG_CONFIG_HOME}" ]]; then
		config_dest="${XDG_CONFIG_HOME}"
	else
		config_dest="${HOME}"
	fi
	config_dest="${config_dest}/.k9s"
else
	echo "No supported system detected. Exiting.."
	exit 1
fi

if [[ ! -d "${config_dest}" && "${config_dest}" != "${HOME}/.k9s" ]]; then
	echo "Symlinking to ${config_dest}"
	ln -s "${HOME}/.k9s/" "${config_dest}"
else
	echo "Something went wrong. Exiting.."
	exit 1
fi
