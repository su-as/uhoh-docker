# uhoh alerts
#
# VERSION 0.0.1

FROM ubuntu:14.04
MAINTAINER Steve Kallestad

#install supervisor
RUN apt-get -y update
RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
#install nodejs
RUN apt-get -y update
RUN apt-get install -y nodejs
RUN apt-get install -y npm
#end install nodejs

#install express
#http://expressjs.com

#install mongodb
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
RUN export LC_ALL=C
RUN apt-get -y update

RUN apt-get install -y mongodb-org
RUN mkdir -p /data/db

#end install mongodb

### GET AN SSH Daemon up and running
RUN apt-get install -y ssh
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

#EXPOSE 22
#CMD ["/usr/sbin/sshd", "-D"]

### END SSH Daemo

RUN mkdir -p /opt/uhoh
RUN cd /opt/uhoh && npm install express

#EXPOSE 27017
#ENTRYPOINT ["/usr/bin/mongod"]

#mongodb is 27017 / ssh 22
EXPOSE 22 27017
CMD ["/usr/bin/supervisord"]
