# uhoh app server
#
# VERSION 0.0.1
#Long Term Supported Ubuntu
FROM ubuntu:14.04 
MAINTAINER Steve Kallestad

RUN export LC_ALL=C
RUN apt-get -y update #get the latest package list

#install supervisor
RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#install ssh
RUN apt-get install -y ssh
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

#install nodejs and related packages
RUN apt-get install -y nodejs npm

RUN mkdir -p /opt/uhoh
WORKDIR /opt/uhoh
RUN npm install http https mongodb express body-parser assert path jade passport passport-saml


RUN wget https://github.com/su-as/uhoh-services/archive/0.5.tar.gz -O uhoh.tar.gz
RUN tar --strip-components=1 -xvzf uhoh.tar.gz


RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN npm install -g node-inspector

EXPOSE 22 3000 3030 5859
CMD ["/usr/bin/supervisord"]
