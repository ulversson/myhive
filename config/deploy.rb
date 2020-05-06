# config valid for current version and patch releases of Capistrano
lock "~> 3.14.0"

set :application, "my_hive"
set :repo_url, "git@github.com:ulversson/myhive.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
 set :deploy_to, "/home/deployer/apps/myhive"



 task :gen_files do
  on roles(:web) do
    within release_path do 
      pp release_path
      execute "MIX_ENV=prod mix systemd.init"
      execute "MIX_ENV=prod mix systemd.generate"
    end
  end
end