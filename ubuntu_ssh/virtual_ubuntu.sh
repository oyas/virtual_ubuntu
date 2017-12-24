#!/bin/bash

image_name="oyas/ubuntu_ssh"
port=2222
mount_point="$HOME:/mnt"

subcmd=$1
running_id=`docker ps -q -f ancestor=$image_name`


#
# ls
#
if [ "$subcmd" = 'ls' ]; then
	docker ps -a -f ancestor=$image_name --format "table {{.ID}}\t{{.Status}}\t{{.CreatedAt}}\t{{.Size}}"
	exit
fi

#
# stop
#
if [ "$subcmd" = 'stop' ]; then
	if [ -n "$running_id" ]; then
		docker stop $running_id
	else
		echo "no docker containers are running."
	fi
	exit
fi

#
# rm
#
if [ "$subcmd" = 'rm' ]; then
	docker $@
	exit
fi

#
# functions
#
check_port_used(){
	#used=`lsof -i:$port`
	used=`netstat -lnt | grep :2222`
	if [ -n "$used" ]; then
		echo "Error: port $port is already used."
		exit
	fi
}

make_new_container(){
	docker run --privileged -d -v $mount_point -p $port:22 $image_name
}

#
# new | start
#
if [ "$subcmd" = 'new' -o "$subcmd" = 'start' ]; then
	if [ -n "$running_id" ]; then
		echo "required to stop the running container."
		echo "$ $(basename $0) stop"
		exit
	else
		check_port_used
		if [ "$subcmd" = 'new' ]; then
			make_new_container
		else
			docker $@
		fi
	fi
	running_id=`docker ps -ql -f ancestor=$image_name`
	subcmd=""
fi

if [ -n "$subcmd" ]; then
	echo "Usage: $(basename $0) [ls | new | start | stop | rm]"
	exit
fi

#
# attach
#
if [ -z "$running_id" ]; then
	id=`docker ps -qal -f ancestor=$image_name`
	check_port_used
	if [ -z "$id" ]; then
		make_new_container
	else
		docker start $id
	fi
	echo "started docker container."
	sleep 1
fi

# login
ssh -p $port localhost
