FROM lsiobase/mono

# set environment variables
ARG DEBIAN_FRONTEND="noninteractive"
ENV XDG_CONFIG_HOME="/config/xdg"

ENV BUILD_APTLIST="wget build-essential"
ENV BASE_APTLIST="libssl-dev nodejs"

# install packages
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
  apt-get install $BUILD_APTLIST $BASE_APTLIST -qy && \
  npm install -g npm@latest && \

  export LIDARR_VERSION="$(curl 'https://ci.appveyor.com/api/projects/lidarr/lidarr/branch/develop' | sed -n 's/.*"version":"\(.*\)",/\1/p' | cut -d\" -f1)" && \
  export LIDARR_BRANCH="$(curl 'https://ci.appveyor.com/api/projects/lidarr/lidarr/branch/develop' | sed -n 's/.*"repositoryBranch":"\(.*\)",/\1/p' | cut -d\" -f1)" && \
  curl -o /tmp/lidarr.tar.gz -L https://ci.appveyor.com/api/projects/Lidarr/lidarr/artifacts/_artifacts/Lidarr.$LIDARR_BRANCH.$LIDARR_VERSION.linux.tar.gz && \
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
