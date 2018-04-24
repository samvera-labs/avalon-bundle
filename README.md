# Avalon Media System
[Avalon Media System](http://www.avalonmediasystem.org) is an open source system for managing large collections of digital audio and video. The project is led by the libraries of [Indiana University](http://www.iu.edu) and [Northwestern University](http://www.northwestern.edu) with funding in part from the [Institute of Museum and Library Services](http://www.imls.gov) and the [Andrew W. Mellon Foundation](https://mellon.org/).

[![CircleCI](https://circleci.com/gh/samvera-labs/avalon-bundle.svg?style=svg)](https://circleci.com/gh/samvera-labs/avalon-bundle) [![Maintainability](https://api.codeclimate.com/v1/badges/e0f5c4b2ac16277b4ecc/maintainability)](https://codeclimate.com/github/samvera-labs/avalon-bundle/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/e0f5c4b2ac16277b4ecc/test_coverage)](https://codeclimate.com/github/samvera-labs/avalon-bundle/test_coverage) [![Stories in Ready](https://img.shields.io/waffle/label/samvera-labs/avalon-bundle/ready.svg?longCache=true&style=flat)](https://waffle.io/avalonmediasystem/avalon)

For more information and regular project updates visit the [Avalon blog](http://www.avalonmediasystem.org/blog).

# Quickstart development with Docker
Docker provides an alternative way of setting up an Avalon Media System Development Environment in minutes without installing any dependencies beside Docker itself. It should be noted that the docker-compose.yml provided here is for development only and will be updated continually.
* Install [Docker](https://docs.docker.com/engine/installation/) and [docker-compose](https://docs.docker.com/compose/install/)
* ```git clone https://github.com/samvera-labs/avalon-bundle```
* ```cd avalon-bundle```
* Use current user as the user for Avalon container `` export AVALON_UID=`id -u` AVALON_GID=`id -g` ``
* ```docker-compose up```
* Try loading Avalon in your browser: ```localhost:3000```

Avalon is served by Puma in development mode so any changes will be picked up automatically. Running a Rails command inside the Avalon container is easy, for example, to run tests ```docker-compose exec avalon bash -c "RAILS_ENV=test bundle exec rspec"```.

Rails debugging with Pry can be accessed by attaching to the docker container: ```docker attach avalon_container_name```. Now, when you reach a binding.pry breakpoint in rails, you can step through the breakpoint in that newly attached session.

## Note for Mac users
*Note: Currently this approach is not stable and still in development mode.  It's recommended you start the application outside of Docker, following the instructions in the following section.*

Bind-mounted volumes are notoriously slow on Docker for Mac, it is recommended that you use [docker-sync](https://github.com/EugenMayer/docker-sync/) to speed up development:
* ``gem install docker-sync``
* ``docker-sync-stack start`` (this replaces ``docker-compose up``)
* ``docker-sync-stack clean`` to bring the stack down (similar to ``docker-compose down``)

# Getting Started (without Docker)

```
bundle install
yarn install
rails db:migrate
rails hydra:server
```

## (Alternative instructions) Getting Started Without Docker for Mac OSX
```
bundle install
yarn install
bundle exec rails db:migrate
```

If you don't have Redis server running automatically on your machine at start up, start it manually:
```
redis-server`
```

Start Solr and Fedora manually:
```
solr_wrapper
fcrepo_wrapper
```

Configure an admin set, so that you can do things like add a new Work:
```
rails hyrax:default_admin_set:create
```

Configure fits; see instructions here, specifically list item #4:
https://github.com/samvera/hyrax/wiki/Configuring-an-OS-X-Samvera-Dev-Environment#configuring-hyrax

Start the application:
```
bundle exec rails s
```

By default it will run on port `:3000`.  If you have a port conflict in your local dev / bash environment, you can specify a port directly, ie:
`bundle exec rails s -p 3333`

Visit `http://localhost:3000/` and make sure the application loads.

Sign up a new user:
```
username: archivist1@example.com
password: archivist1
```
