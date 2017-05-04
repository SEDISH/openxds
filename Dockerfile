#
# OpenXDS
#
#

FROM uwitech/ohie-base

# Install dependencies
RUN apt-get update && \
apt-get install -y git build-essential curl wget software-properties-common

# Install Java
RUN \
  echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java7-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk7-installer

# Install dockerize
ENV DOCKERIZE_VERSION v0.2.0
RUN curl -L "https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz" -o "/tmp/dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz" \
    && tar -C /usr/local/bin -xzvf "/tmp/dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz"

# Install database clients
RUN apt-get update && apt-get install -y postgresql-client

# Install OpenXDS
ENV HOME_SHARE="/opt"

RUN mkdir -p "${HOME_SHARE}/openxds/" \
    && curl -L "https://github.com/jembi/openxds/releases/download/v1.1.2/openxds.tar.gz" \
            -o ${HOME_SHARE}/openxds.tar.gz \
    && tar -zxvf ${HOME_SHARE}/openxds.tar.gz -C ${HOME_SHARE}/openxds \
    && rm ${HOME_SHARE}/openxds.tar.gz

ADD IheActors.xml ${HOME_SHARE}/openxds/IheActors.xml
RUN chmod +x ${HOME_SHARE}/openxds/IheActors.xml

ADD openxds.log ${HOME_SHARE}/openxds/openxds.log
RUN chmod +x ${HOME_SHARE}/openxds/openxds.log

# Expose ports
EXPOSE 8010
EXPOSE 8020

RUN cd ${HOME_SHARE}/openxds/
ADD run.sh ${HOME_SHARE}/openxds/run.sh
RUN chmod +x ${HOME_SHARE}/openxds/run.sh

RUN rm -f ${HOME_SHARE}/openxds/openxds.properties
ADD openxds.properties ${HOME_SHARE}/openxds/openxds.properties
RUN chmod +x ${HOME_SHARE}/openxds/openxds.properties

# Run using dockerize
CMD ["dockerize","-wait","tcp://postgresql-openxds:5432","-timeout","100s","/opt/openxds/run.sh", "run"]
