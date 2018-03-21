# config valid for current version and patch releases of Capistrano
lock ">=3.6.1"

set :application, ENV['APP_NAME'] || "avalonbundledev"
set :repo_url, ENV['REPO'] || "git://github.com/samvera-labs/avalon-bundle.git"

# If BRANCH is set, use it. Otherwise, ask for a branch, defaulting to the currently checked out branch.
set :branch, ENV['BRANCH'] || ask(:branch, `git rev-parse --abbrev-ref HEAD`.chomp)

set :deploy_to, ENV['DEPLOY_TO'] || "/srv/avalon/avalon-bundle"
set :user, ENV['DEPLOY_USER'] || 'avalon'

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
