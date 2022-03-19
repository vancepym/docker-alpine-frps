#!/bin/sh
set -e

if [ -n "$1" ]; then
	if [ "$1" = "devel" ]; then
		exec sh -l
	fi
fi

if [ -e /etc/frp/frps.ini ]; then
	/usr/bin/frps -c /etc/frp/frps.ini
else
	/usr/bin/frps
fi

exec syslogd -n -t -O -
