FROM ivonet/openjdk:11.0.1

LABEL maintainer="Ivo Woltring, ivonet.nl" description="WildFly 14.0.1.Final"

ENV WILDFLY_VERSION 15.0.1.Final
# https://repo1.maven.org/maven2/org/wildfly/wildfly-dist/15.0.1.Final/
ENV WILDFLY_SHA1 23d6a5889b76702fc518600fc5b2d80d6b3b7bb1
ENV JBOSS_HOME /opt/jboss/wildfly

USER root

RUN groupadd -r jboss -g 1000 \
 && useradd -u 1000 -r -g jboss -m -d /opt/jboss -s /sbin/nologin -c "JBoss user" jboss \
 && chmod 755 /opt/jboss

RUN cd $HOME \
 && curl -O https://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz \
 && sha1sum wildfly-$WILDFLY_VERSION.tar.gz | grep $WILDFLY_SHA1 \
 && tar xf wildfly-$WILDFLY_VERSION.tar.gz \
 && mv $HOME/wildfly-$WILDFLY_VERSION $JBOSS_HOME \
 && rm -f wildfly-$WILDFLY_VERSION.tar.gz \
 && ln -s /opt/jboss/wildfly/standalone/deployments /deployments \
 && chown -R jboss:0 ${JBOSS_HOME} \
 && chmod -R g+rw ${JBOSS_HOME} \
 && /opt/jboss/wildfly/bin/add-user.sh admin s3cr3t --silent

ENV LAUNCH_JBOSS_IN_BACKGROUND true

USER jboss

VOLUME ["/deployments"]
EXPOSE 8080 9990

CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
