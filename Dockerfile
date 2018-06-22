FROM nvidia/cuda-ppc64le:9.0-cudnn7-runtime-ubuntu16.04
MAINTAINER H2o.ai <ops@h2o.ai>

# Nimbix base OS
ENV DEBIAN_FRONTEND noninteractive

RUN \
  apt-get -y update && \
  apt-get install -y \
  curl \
  wget

# Nimbix Common
RUN \
  curl -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/nimbix/image-common/master/install-nimbix.sh | bash

# Notebook Common
ADD https://raw.githubusercontent.com/nimbix/notebook-common/master/install-ubuntu.sh /tmp/install-ubuntu.sh
RUN \
  bash /tmp/install-ubuntu.sh 3 && \
  rm -f /tmp/install-ubuntu.sh

# Setup Repos
RUN \
  apt-get install -y \
  apt-utils \
  software-properties-common \
  python-software-properties \
  default-jre
  
# Get R
WORKDIR /opt

# Install H2o
RUN \
  wget --no-check-certificate http://h2o-release.s3.amazonaws.com/h2o/rel-wright/2/h2o-3.20.0.2.zip -O /opt/h2o-latest.zip && \
  unzip -d /opt /opt/h2o-latest.zip && \
  rm /opt/h2o-latest.zip && \
  cd /opt && \
  cd `find . -name 'h2o.jar' | sed 's/.\///;s/\/h2o.jar//g'` && \ 
  cp h2o.jar /opt

EXPOSE 22
EXPOSE 54321
  
# Copy bash scripts
COPY scripts/start-h2o3.sh /opt/start-h2o3.sh
COPY scripts/make-flatfile.sh /opt/make-flatfile.sh
COPY scripts/start-cluster.sh /opt/start-cluster.sh
COPY scripts/sssh /opt/sssh

# Set executable on scripts
RUN \
  chown -R nimbix:nimbix /opt && \
  chmod +x /opt/start-h2o3.sh && \
  chmod +x /opt/make-flatfile.sh && \
  chmod +x /opt/start-cluster.sh && \
  chmod +x /opt/sssh 

# Nimbix Integrations
ADD ./NAE/AppDef.json /etc/NAE/AppDef.json
ADD ./NAE/AppDef.png /etc//NAE/default.png
ADD ./NAE/screenshot.png /etc/NAE/screenshot.png
