FROM python:2.7

MAINTAINER Phuwanat Sakornsakolpat (phuwanat.sak@mahidol.edu)

RUN apt-get update & \
	apt-get -y install git

RUN git clone https://github.com/phuwanat/checkVCF.git