# uhoh app server
#
# VERSION 0.0.1
#Long Term Supported Ubuntu
FROM ubuntu:14.04 
MAINTAINER Steve Kallestad

#set up directories and environment variables
RUN export LC_ALL=C
RUN mkdir -p /opt/uhoh

#get the latest package list
RUN apt-get -y update 

#install nodejs and related packages
RUN apt-get install -y nodejs npm wget
RUN ln -s /usr/bin/nodejs /usr/bin/node

#install the necessary node.js libraries
WORKDIR /opt/uhoh
RUN npm install http \
    		https \
		mongodb \
		express \
		body-parser \
		assert \
		path \
		jade \
		passport \
		passport-saml \
		method-override \
		errorhandler \
		mongoose \
		winston \
		nodemailer \
		util \
		socket.io \
		url \
		fs \
		express-session

#download and install the latest release of uhoh
RUN wget -qO- https://api.github.com/repos/su-as/uhoh-services/releases \
    | grep tarball_url \
    | head -1 \
    | awk '{print $2}' \
    | sed "s/[\",\,]//g" \
    | xargs wget -O uhoh.tar.gz
    
#RUN wget https://github.com/su-as/uhoh-services/archive/0.9.tar.gz -O uhoh.tar.gz
RUN tar --strip-components=1 -xvzf uhoh.tar.gz

#install debugger
RUN npm install -g node-inspector

EXPOSE 3000 5859
CMD ["/usr/bin/node /opt/uhoh/index.js"]
