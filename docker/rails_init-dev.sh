#!/bin/bash
# Workaround for git clone problem when a non-existing uid:gid is used 
export GIT_COMMITTER_NAME=avalon
export GIT_COMMITTER_EMAIL=avalon@example.edu

cd /home/app/avalon
export HOME=/home/app/avalon

echo " `date` : Bundle config"
bundle config build.nokogiri --use-system-libraries

echo " `date` : Bundle install"
bundle install --with development test

echo " `date` : Yarn install"
yarn install

echo " `date` : Remove server pid"
rm -f tmp/pids/server.pid

echo " `date` : Rake tasks"
bundle exec rails db:migrate hyrax:default_collection_types:create hyrax:default_admin_set:create

echo " `date` : Starting the rails server"
bundle exec rails server -b 0.0.0.0 -p 3000 

# WEBPACKER_DEV_SERVER_HOST=0.0.0.0 $NODE_PATH/.bin/webpack-dev-server --config /home/app/avalon/config/webpack/development.js

# Be able to restart rails server without killing the container
tail -f /dev/null
