FROM openjdk:8-jdk

MAINTAINER jamie-b

RUN apt-get update && apt-get install -y git curl wget netcat nmap net-tools sudo && rm -rf /var/lib/apt/lists/*


ENV JENKINS_HOME /var/jenkins_home
ENV COPY_REFERENCE_FILE_LOG $JENKINS_HOME/copy_reference_file.log

RUN groupadd -g 1000 jenkins \
    && useradd -d "$JENKINS_HOME" -u 1000 -g 1000 -m -s /bin/bash jenkins \
    && adduser jenkins sudo \
    && echo 'jenkins:jenkins' | chpasswd
    
ENV TINI_VERSION v0.14.0
ADD https://github.com/wwce/terraform/blob/master/azure/Jenkins_proj-master/jenkins/tini?raw=true /bin/tini
RUN chmod +x /bin/tini

ENV JENKINS_VERSION 2.32.1
RUN set -ex \
    && [ -e /usr/share/jenkins ] || mkdir -p /usr/share/jenkins \
    && [ -e /usr/share/jenkins/ref ] || mkdir -p /usr/share/jenkins/ref \
    && wget https://s3.amazonaws.com/jenkinsploit/jenkins-2-32.war -O /usr/share/jenkins/jenkins.war -q --progress=bar:force:noscroll --show-progress \
    && chown -R jenkins "$JENKINS_HOME" /usr/share/jenkins/ref

EXPOSE 8080
EXPOSE 50000

COPY jenkins.sh /usr/local/bin/jenkins.sh

RUN chmod +x /usr/local/bin/jenkins.sh

USER root

ENTRYPOINT ["/bin/tini", "--"]

CMD ["/usr/local/bin/jenkins.sh"]
