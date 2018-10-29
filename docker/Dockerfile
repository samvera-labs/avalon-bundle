FROM        ruby:2.4.4-jessie
MAINTAINER  Phuong Dinh <pdinh@indiana.edu>

RUN         curl -sS http://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
         && echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
         && curl -sL http://deb.nodesource.com/setup_8.x | bash - \
         && echo "deb http://ftp.uk.debian.org/debian jessie-backports main" >> /etc/apt/sources.list \
         && wget https://mediaarea.net/repo/deb/repo-mediaarea_1.0-6_all.deb && dpkg -i repo-mediaarea_1.0-6_all.deb 

RUN         apt-get update && apt-get upgrade -y build-essential nodejs \
         && apt-get install -y --force-yes -t jessie-backports \
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
         && rm -rf /var/lib/apt/lists/* \
         && mkdir -p /tmp/phantomjs \
         && curl -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 | tar -xj --strip-components=1 -C /tmp/phantomjs \
         && mv /tmp/phantomjs/bin/phantomjs /usr/local/bin \
         && mkdir -p /tmp/ffmpeg && cd /tmp/ffmpeg \
         && curl https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-64bit-static.tar.xz | tar xJ \
         && cp `find . -type f -executable` /usr/bin/ \
         && ln -s /usr/bin/lsof /usr/sbin/

ARG         FITS_VER=1.2.0
RUN         curl -fSL -o fits-${FITS_VER}.zip http://projects.iq.harvard.edu/files/fits/files/fits-${FITS_VER}.zip \
         && unzip fits-${FITS_VER}.zip -d /usr/local/bin/ \
         && chmod +X /usr/local/bin/fits-${FITS_VER}/fits.sh
ENV         PATH "$PATH:/usr/local/bin/fits-${FITS_VER}"

RUN         mkdir -p /home/app/avalon \
         && mkdir -p /home/app/node_modules && chmod 777 /home/app/node_modules

WORKDIR     /home/app/avalon

ENV         RAILS_ENV=development
ADD         rails_init-dev.sh /
