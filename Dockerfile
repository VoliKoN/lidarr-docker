FROM lsiobase/mono

# set environment variables
ARG DEBIAN_FRONTEND="noninteractive"

ENV BUILD_APTLIST="wget build-essential"
ENV BASE_APTLIST="libssl-dev nodejs"

# install packages
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
  apt-get install $BUILD_APTLIST $BASE_APTLIST -qy && \
  npm install -g npm@latest && \

#  export LIDARR_VERSION="0.2.0.50" && \
#  export LIDARR_BRANCH="$(curl 'https://ci.appveyor.com/api/projects/lidarr/lidarr' | sed -n 's/.*"repositoryBranch":"\(.*\)",/\1/p' | cut -d\" -f1)" && \
  curl -o /tmp/lidarr.tar.gz -L https://ci.appveyor.com/api/buildjobs/a0kncuv541be6le3/artifacts/_artifacts/Lidarr.react.0.2.0.50.linux.tar.gz && \
  mkdir -p /opt/lidarr && \
  tar xzvf /tmp/lidarr.tar.gz -C /opt/lidarr --strip-components=1 && \
  cd /opt/lidarr && npm install && npm run && \

# cleanup
  apt-get purge -y --auto-remove $BUILD_APTLIST && \
  apt-get clean && \
  rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8686
VOLUME /config /downloads /music
