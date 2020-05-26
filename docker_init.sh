#!/bin/bash
# Workaround for git clone problem when a non-existing uid:gid is used 
export GIT_COMMITTER_NAME=avalon
export GIT_COMMITTER_EMAIL=avalon@example.edu

echo " `date` : Bundle install"
bundle install $BUNDLE_FLAGS 

echo " `date` : Yarn install"
yarn install

echo " `date` : Remove server pid"
rm -f tmp/pids/server.pid

echo " `date` : Rake tasks"
bundle exec rails db:migrate hyrax:default_collection_types:create
bundle exec rails hyrax:default_admin_set:create # Needs to be a separate rake call
