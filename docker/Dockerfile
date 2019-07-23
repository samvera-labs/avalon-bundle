FROM        ruby:2.5.5-stretch
MAINTAINER  Phuong Dinh <pdinh@indiana.edu>

RUN         curl -sS http://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
         && echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
         && curl -sL http://deb.nodesource.com/setup_8.x | bash - \
         && echo "deb http://deb.debian.org/debian stretch-backports main" >> /etc/apt/sources.list \
         && wget https://mediaarea.net/repo/deb/repo-mediaarea_1.0-6_all.deb && dpkg -i repo-mediaarea_1.0-6_all.deb

RUN         apt-get update && apt-get upgrade -y build-essential nodejs \
         && apt-get install -y \
            mediainfo \
            x264 \
            cmake \
            pkg-config \
            lsof \
            sendmail \
            tzdata \
            yarn \
            vim \
            graphicsmagick \
            zip \
            unzip \
            openjdk-8-jre-headless \
            ca-certificates-java \
         && rm -rf /var/lib/apt/lists/*

RUN         mkdir -p /tmp/phantomjs \
         && curl -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 | tar -xj --strip-components=1 -C /tmp/phantomjs \
         && mv /tmp/phantomjs/bin/phantomjs /usr/local/bin \
         && mkdir -p /tmp/ffmpeg && cd /tmp/ffmpeg \
         && curl https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz | tar xJ \
         && cp `find . -type f -executable` /usr/bin/ \
         && ln -s /usr/bin/lsof /usr/sbin/

ARG         FITS_VER=1.4.1
RUN         curl -fSL -o fits-${FITS_VER}.zip https://github.com/harvard-lts/fits/releases/download/${FITS_VER}/fits-${FITS_VER}.zip \
         && mkdir /usr/local/bin/fits-${FITS_VER} \
         && unzip fits-${FITS_VER}.zip -d /usr/local/bin/fits-${FITS_VER} \
         && chmod +X /usr/local/bin/fits-${FITS_VER}/fits.sh \
         && ln -s /usr/local/bin/fits-${FITS_VER}/tools/mediainfo/linux/libzen.so.0 /usr/local/bin/fits-${FITS_VER}/tools/mediainfo/linux/`basename /usr/lib/x86_64-linux-gnu/libzen.so.0.*`
ENV         PATH "$PATH:/usr/local/bin/fits-${FITS_VER}"

ADD         . /home/app/avalon
WORKDIR     /home/app/avalon

RUN         mkdir -p /home/app/avalon/node_modules && chmod 777 /home/app/avalon/node_modules \ 
         && mkdir -p /usr/local/bundle && chmod 777 /usr/local/bundle

ENV         RAILS_ENV=development
ADD         docker/rails_init-dev.sh /
