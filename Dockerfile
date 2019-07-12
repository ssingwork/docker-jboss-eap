FROM jboss/base-jdk:7
MAINTAINER Jose Manuel Moreno Gavira <josem.moreno.gavira@gmail.com>

VOLUME ["/data/apps","/data/apps/deploy","/data/apps/CONFIG/properties","/data/apps/CONFIG/jars","/home/logs"]

USER	root

# locales
# RUN		yum -y update
ENV		LANG en_US.utf8

# jboss eap 5.2 (jboss files)
ENV		JBOSS_EAP_HOME /opt/jboss/eap-5.2
COPY	files/jboss-eap-5.2.tar.gz-part-* /opt/jboss/
RUN		cat /opt/jboss/jboss-eap-5.2.tar.gz-part-* > /opt/jboss/jboss-eap-5.2.tar.gz
RUN		tar -zxvf /opt/jboss/jboss-eap-5.2.tar.gz -C /opt/jboss/
RUN		mv /opt/jboss/jboss-eap-5.2 /opt/jboss/eap-5.2
RUN		rm -rf /opt/jboss/jboss-eap-5.2.tar.gz*
RUN		ln -s /opt/jboss/jboss-eap* ${JBOSS_EAP_HOME}


# jboss snapshot (jboss server configuration)
#COPY	files/myconf.tar.gz-part-* ${JBOSS_EAP_HOME}/jboss-as/server/
#RUN		cat ${JBOSS_EAP_HOME}/jboss-as/server/myconf.tar.gz-part-* > ${JBOSS_EAP_HOME}/jboss-as/server/myconf.tar.gz
#RUN		tar -zxvf ${JBOSS_EAP_HOME}/jboss-as/server/myconf.tar.gz -C ${JBOSS_EAP_HOME}/jboss-as/server/
#RUN		rm -rf ${JBOSS_EAP_HOME}/jboss-as/server/myconf.tar.gz*

#COPY CUSTOM configuration files
COPY custom_files/conf ${JBOSS_EAP_HOME}/jboss-as/server/all/conf

# remove all unused configuration except default
RUN		rm -rf ${JBOSS_EAP_HOME}/jboss-as/server/default
RUN		rm -rf ${JBOSS_EAP_HOME}/jboss-as/server/minimal
RUN		rm -rf ${JBOSS_EAP_HOME}/jboss-as/server/production 
RUN		rm -rf ${JBOSS_EAP_HOME}/jboss-as/server/standard 
RUN		rm -rf ${JBOSS_EAP_HOME}/jboss-as/server/web

# shell scripts
COPY	files/jboss-eap	/usr/local/bin/
RUN     sed -i -e 's/\r$//' /usr/local/bin/jboss-eap
RUN		chmod +x /usr/local/bin/jboss-eap

# launch JBoss using default profile
#ENTRYPOINT	["/usr/local/bin/jboss-eap", "default"]
