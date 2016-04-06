FROM cogniteev/oracle-java:java8
RUN apt-get update
RUN apt-get install -y xvfb libxext6 libxi6 libxtst6 libxrender1 unzip curl
RUN curl -L -o /var/tmp/webswing-2.3-distribution.zip https://bitbucket.org/meszarv/webswing/downloads/webswing-2.3-distribution.zip
ENV CORALBASE=http://coral.nanofab.utah.edu/coral/lib/
RUN mkdir /var/tmp/coral
WORKDIR /var/tmp/coral

RUN for i in castor-core.jar \
	castor-xml.jar \
	castor-xml-schema.jar \
	config.jar \
	coral.jar \
	jcommon.jar \
	jfreechart.jar \
	log4j.jar \
	logging-api.jar \
	logging.jar \
	mail.jar \
	provider.jar \
	regexp.jar \
	xacml.jar \
	xalan.jar \
	xerces.jar \
	xml-apis.jar; do curl -O $CORALBASE/$i; done

RUN unzip /var/tmp/webswing-2.3-distribution.zip -d /home && \
	mv /home/webswing-2.3 /home/webswing && \
	useradd webswing && \
	chsh -s /bin/bash webswing && \
	chown -R webswing /home/webswing/ && \
	ln -s /usr/lib/jvm/java-8-oracle/ /opt/java8 && \
	rm /var/tmp/webswing-2.3-distribution.zip

ADD webswing.config /home/webswing/webswing.config
ADD webswing.sh /home/webswing/webswing.sh
RUN chown -R webswing /home/webswing/
WORKDIR /home/webswing

###
### IN CASE WE WANT SSH -Y CAPABILITY
###
RUN apt-get install -y openssh-server && \
	(echo 'service ssh start' >> /root/.bashrc) && \
	(echo 'webswing:8sQj9IjBPLtunefF6Tn' | chpasswd)
### 
### END OF SSH STUFF
### 

RUN echo 'http://localhost:8080/?app=Coral&anonym=true for location of app'  && \
	(echo '/home/webswing/webswing.sh start &' >> /root/.bashrc) && \
	(echo "echo 'http://localhost:8080/?app=Coral&anonym=true for location of app'" >> /root/.bashrc)

CMD ["/home/webswing/webswing.sh", "start"]
