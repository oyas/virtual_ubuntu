FROM       ubuntu:16.04

ARG user="user"

# update
RUN apt-get update && apt-get -y upgrade

# set locale
#RUN apt-get -y install locales
#RUN locale-gen en_US.UTF-8
#ENV LANG en_US.UTF-8
#ENV LANGUAGE en_US:en
#ENV LC_ALL en_US.UTF-8
RUN apt-get -y install language-pack-ja-base language-pack-ja
RUN locale-gen ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:en
ENV LC_ALL ja_JP.UTF-8

# add new user
#RUN useradd -m $user -s /bin/bash && echo "$user:$pass" | chpasswd && gpasswd -a $user sudo
RUN useradd -m $user -s /bin/bash && gpasswd -a $user sudo

# install other commands
RUN apt-get install -y sudo
RUN apt-get install -y vim git

# allow no-password sudo
RUN echo "\n# Allow user to execute sudo without password\n$user ALL=NOPASSWD: ALL" >> /etc/sudoers

# set login user
ENV HOME /home/$user
WORKDIR /home/$user
USER $user

# run dummy command
#CMD ['bash -c "bash --rcfile <(echo \"trap 'exit 0' TERM\")"']
#CMD ["/bin/bash", "-c", "trap 'exit 0' TERM; while true; do sleep 1; done"]
CMD ["env", "TERM=xterm", "watch", ":"]
