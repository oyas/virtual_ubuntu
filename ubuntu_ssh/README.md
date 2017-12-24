http://kotaroito.hatenablog.com/entry/2016/03/07/094423


# build

	$ docker build -t oyas/ubuntu_ssh .


# run

	$ docker run --privileged -d -p 2222:22 oyas/ubuntu_ssh
