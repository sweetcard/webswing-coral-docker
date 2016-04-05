FROM cogniteev/oracle-java:java8
RUN apt-get update
RUN apt-get install -y xvfb libxext6 libxi6 libxtst6 libxrender1 unzip curl
RUN curl -L -o /var/tmp/webswing-2.3-distribution.zip https://bitbucket.org/meszarv/webswing/downloads/webswing-2.3-distribution.zip
ADD coral /var/tmp/coral
WORKDIR /var/tmp
RUN unzip webswing-2.3-distribution.zip -d /home
RUN mv /home/webswing-2.3 /home/webswing
RUN useradd webswing
RUN chsh -s /bin/bash webswing
RUN chown -R webswing /home/webswing/
RUN ln -s /usr/lib/jvm/java-8-oracle/ /opt/java8
ADD webswing.config /home/webswing/webswing.config
ADD webswing.sh /home/webswing/webswing.sh
RUN chown -R webswing /home/webswing/
WORKDIR /home/webswing

###
### IN CASE WE WANT SSH -Y CAPABILITY
###
RUN apt-get install -y openssh-server
RUN echo 'service ssh start' >> /root/.bashrc
RUN echo 'webswing:8sQj9IjBPLtunefF6Tn' | chpasswd
### 
### END OF SSH STUFF
### 

RUN echo 'http://localhost:8080/?app=Coral&anonym=true for location of app' 
RUN echo '/home/webswing/webswing.sh start &' >> /root/.bashrc
RUN echo "echo 'http://localhost:8080/?app=Coral&anonym=true for location of app'" >> /root/.bashrc

CMD ["/home/webswing/webswing.sh", "start"]
