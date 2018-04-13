server ENV['APP_HOST'], roles: %w{app}, user: fetch(:user)
append :linked_files, "docker-compose.local.yml"

namespace :docker do
  task :up do
    on roles(:all) do |host|
      within release_path do
        execute :"docker-compose", "pull"
        execute :"docker-compose", "-f docker-compose.yml -f docker-compose.local.yml -p #{fetch(:application)} up -d"
      end
    end
  end
end

after "deploy:updated", "docker:up"
after "deploy:rollback", "docker:up"
