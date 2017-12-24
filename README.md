# Virtual Ubuntu

Easy to make temporary Ubuntu environment by using docker.

## Usage

	$ ./virtual_ubuntu.sh

## install docker

See <https://docs.docker.com/engine/installation/>

If you are using Ubuntu, see <https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-repository>

Recommend to add `docker` group to use `virtual_ubuntu.sh` without `sudo`:

	$ sudo usermod -aG docker $USER
