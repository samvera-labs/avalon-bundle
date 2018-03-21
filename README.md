# README

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

# Getting Started (without Docker)

```
bundle install
yarn install
rails db:migrate
rails hydra:server
```
