#!/bin/bash

image_name="oyas/virtual_ubuntu"
mount_point="$HOME:/mnt"
#exec_command="env TERM=xterm-256color bash"
exec_command="bash"

subcmd=$1
running_id=`docker ps -ql --filter ancestor=$image_name --filter status=running`


#
# check if docker installed
#
if type docker 2>/dev/null 1>/dev/null
then
	:
else
	echo "docker is not installed."
	echo "To install docker, see https://docs.docker.com/engine/installation/"
	echo "If using Ubuntu, see https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-repository"
	exit
fi

#
# functions
#
make_new_container(){
	docker run --privileged -d -v $mount_point $@ $image_name
}

#
# ls
#
if [ "$subcmd" = 'ls' ]; then
	docker ps -a -f ancestor=$image_name --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.CreatedAt}}\t{{.Size}}"
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
# new | start
#
if [ "$subcmd" = 'new' -o "$subcmd" = 'start' ]; then
	if [ -n "$running_id" ]; then
		echo "[Error] required to stop the running container."
		echo "  $ $(basename $0) stop"
		exit 1
	else
		if [ "$subcmd" = 'new' ]; then
			option=$2
			if [ -n "$option" ]; then
				option="--name $option"
			fi
			make_new_container $option
		else
			docker $@
		fi
	fi
	running_id=`docker ps -ql --filter ancestor=$image_name --filter status=running`
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
	if [ -z "$id" ]; then
		make_new_container
	else
		docker start $id
	fi
	echo "started docker container."
	sleep 1
	running_id=`docker ps -ql --filter ancestor=$image_name --filter status=running`
fi

docker exec -it $running_id $exec_command
