FROM ubuntu:20.04
RUN apt update
RUN echo "-------------------------"
RUN echo "first install debconf-utils and set the default selections"
RUN echo "-------------------------"
RUN apt install debconf-utils
RUN echo tzdata tzdata/Areas select Europe | debconf-set-selections
RUN echo tzdata tzdata/Zones/Europe select Istanbul | debconf-set-selections
RUN apt install iputils-ping net-tools iproute2 -y
RUN apt install vim wget -y
RUN apt-get install python3 -y
RUN apt-get update
RUN apt-get install python3-pip -y
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN ln -s /usr/bin/pip3 /usr/bin/pip
    