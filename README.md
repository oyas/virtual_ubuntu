# Virtual Ubuntu

Easy to make temporary Ubuntu environment by using docker.


## Usage

	$ ./virtual_ubuntu.sh

Create new Ubuntu container or attach last used container.
And login the container.

### Sub-commands

	$ ./virtual_ubuntu.sh ls

Show existing Ubuntu environments (docker containers).

	$ ./virtual_ubuntu.sh new

Create new Ubuntu environment.

	$ ./virtual_ubuntu.sh start [container_name]

Start existing container.

	$ ./virtual_ubuntu.sh stop

Stop running container.

	$ ./virtual_ubuntu.sh rm [container_name]

Remove existing container.


## Install docker

See <https://docs.docker.com/engine/installation/>

If you are using Ubuntu, see <https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-repository>

Recommend to add `docker` group to use `virtual_ubuntu.sh` without `sudo`:

	$ sudo usermod -aG docker $USER
