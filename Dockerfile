# Base stage for building gems
FROM        ruby:2.5-buster as bundle
RUN         echo "deb http://deb.debian.org/debian buster-backports main" >> /etc/apt/sources.list \
         && apt-get update && apt-get upgrade -y build-essential \
         && apt-get install -y --no-install-recommends \
            cmake \
            pkg-config \
            zip \
            git \
         && rm -rf /var/lib/apt/lists/* \
         && apt-get clean

COPY        Gemfile ./Gemfile
COPY        Gemfile.lock ./Gemfile.lock

RUN         gem install bundler -v "$(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1)" \
         && bundle config build.nokogiri --use-system-libraries


# Build development gems
FROM        bundle as bundle-dev
RUN         bundle install --with aws development test postgres --without production 


# Download binaries in parallel
FROM        ruby:2.5-buster as download
RUN         curl -L https://github.com/jwilder/dockerize/releases/download/v0.6.1/dockerize-linux-amd64-v0.6.1.tar.gz | tar xvz -C /usr/bin/
RUN         curl https://chromedriver.storage.googleapis.com/2.46/chromedriver_linux64.zip -o /usr/local/bin/chromedriver \
         && chmod +x /usr/local/bin/chromedriver
RUN         curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /chrome.deb
RUN         mkdir -p /tmp/ffmpeg && cd /tmp/ffmpeg \
         && curl https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz | tar xJ \
         && cp `find . -type f -executable` /usr/bin/

ARG         FITS_VER=1.4.1
RUN         curl -fSL -o fits-${FITS_VER}.zip https://github.com/harvard-lts/fits/releases/download/${FITS_VER}/fits-${FITS_VER}.zip \
         && mkdir /usr/local/bin/fits-${FITS_VER} \
         && unzip fits-${FITS_VER}.zip -d /usr/local/bin/fits-${FITS_VER} \
         && chmod +X /usr/local/bin/fits-${FITS_VER}/fits.sh


# Base stage for building final images
FROM        ruby:2.5-slim-buster as base
RUN         apt-get update && apt-get install -y --no-install-recommends curl gnupg2 \
         && curl -sL http://deb.nodesource.com/setup_10.x | bash - \
         && curl -O https://mediaarea.net/repo/deb/repo-mediaarea_1.0-16_all.deb && dpkg -i repo-mediaarea_1.0-16_all.deb 

RUN         apt-get update && apt-get install -y --no-install-recommends --allow-unauthenticated \
            nodejs \
            lsof \
            x264 \
            sendmail \
            git \
            libxml2-dev \
            libxslt-dev \
            libpq-dev \
            mediainfo \
            openssh-client \
            zip \
            dumb-init \
         && ln -s /usr/bin/lsof /usr/sbin/ \
        && npm install --global yarn

RUN         useradd -m -U app \
         && su -s /bin/bash -c "mkdir -p /home/app/avalon" app
WORKDIR     /home/app/avalon

ARG         FITS_VER=1.4.1
COPY        --from=download /usr/bin/ff* /usr/bin/
COPY        --from=download /usr/local/bin/fits-${FITS_VER} /usr/local/bin/fits-${FITS_VER}

RUN         ln -s /usr/local/bin/fits-${FITS_VER}/tools/mediainfo/linux/libzen.so.0 /usr/local/bin/fits-${FITS_VER}/tools/mediainfo/linux/`basename /usr/lib/x86_64-linux-gnu/libzen.so.0.*`


# Build devevelopment image
FROM        base as dev
RUN         apt-get install -y --no-install-recommends --allow-unauthenticated \
            build-essential \
            cmake

COPY        --from=bundle-dev /usr/local/bundle /usr/local/bundle
COPY        --from=download /chrome.deb /
COPY        --from=download /usr/local/bin/chromedriver /usr/local/bin/chromedriver
COPY        --from=download /usr/bin/dockerize /usr/bin/
ADD         docker_init.sh /

ARG         RAILS_ENV=development
RUN         dpkg -i /chrome.deb || apt-get install -yf


# Build production gems
FROM        bundle as bundle-prod
RUN         bundle install --without development test --with aws production postgres


# Install node modules
FROM        node:10.24-buster-slim as node-modules
RUN         apt-get update && apt-get install -y --no-install-recommends git
COPY        package.json .
COPY        yarn.lock .
RUN         yarn install


# Build production assets
FROM        base as assets
COPY        --from=bundle-prod --chown=app:app /usr/local/bundle /usr/local/bundle
COPY        --chown=app:app . .
COPY        --from=node-modules --chown=app:app /node_modules ./node_modules

USER        app
ENV         RAILS_ENV=production

RUN         SECRET_KEY_BASE=$(ruby -r 'securerandom' -e 'puts SecureRandom.hex(64)') bundle exec rake webpacker:compile
RUN         SECRET_KEY_BASE=$(ruby -r 'securerandom' -e 'puts SecureRandom.hex(64)') bundle exec rake assets:precompile
RUN         cp config/controlled_vocabulary.yml.example config/controlled_vocabulary.yml


# Build production image
FROM        base as prod
COPY        --from=assets --chown=app:app /home/app/avalon /home/app/avalon
COPY        --from=bundle-prod --chown=app:app /usr/local/bundle /usr/local/bundle

USER        app
ENV         RAILS_ENV=production
