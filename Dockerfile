FROM ubuntu:16.04

ENV TERM linux
ENV ENV DEBIAN_FRONTEND noninteractive

#For now copying deb files over to install
COPY build_host_setup_debian.sh /usr/local/bin/
COPY mycroft-core-amd64_0.8.12-1.deb /usr/local/bin
COPY mimic-amd64_1.2.0.2-1.deb /usr/local/bin

# Install Server Dependencies for Mycroft
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -yq --no-install-recommends \
  supervisor \
  apt-transport-https \
  dnsmasq \
  avrdude \
  jq \
  pulseaudio \
  alsa-utils && \
  cd /usr/local/bin && \
  /bin/bash build_host_setup_debian.sh && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F3B1AA8B && \
  bash -c 'echo "deb http://repo.mycroft.ai/repos/apt/debian debian main" > /etc/apt/sources.list.d/repo.mycroft.ai.list' && \
  apt-get update && \
  apt-get install -yq mycroft-core && \
  apt-get install -f && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*


WORKDIR /home/mycroft
EXPOSE 8181
CMD ["/bin/bash"]
