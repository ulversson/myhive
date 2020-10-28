# config valid for current version and patch releases of Capistrano

lock "~> 3.14.0"

set :application, "myhive"
set :repo_url, "git@github.com:ulversson/myhive.git"
set :deploy_to, "/home/deployer/apps/myhive"
set :bundle_binstubs, -> { "#{fetch(:deploy_to)}/current/_build/prod/rel/my_hive/bin" }

append :linked_files, '.env'  # for capistrano >= 3.5


task "deps_get" do
  on roles(:app) do 
    within repo_path do
      execute "cd #{fetch(:release_path)} && mix deps.get"
    end
  end  
end

task :gen_system_d do
  on roles(:web) do
    within release_path do 
      execute "source #{shared_path}/.env && cd #{fetch(:release_path)} && MIX_ENV=prod mix systemd.init"
      execute "source #{shared_path}/.env && cd #{fetch(:release_path)} && MIX_ENV=prod mix systemd.generate"
    end
  end
end

task :gen_deploy_files do
  on roles(:web) do
    within release_path do 
      execute "source #{shared_path}/.env && cd #{fetch(:release_path)} && MIX_ENV=prod mix deploy.init"
      execute "source #{shared_path}/.env && cd #{fetch(:release_path)} && MIX_ENV=prod mix deploy.generate"
    end
  end
end

task "upload_build_script" do
  on roles(:web) do
    within release_path do 
      upload! './config/build', "#{release_path}/bin/build"
      execute "source #{shared_path}/.env && chmod 775 '#{release_path}/bin/build' "
    end
  end    
end

task "exec_build_script" do
  on roles(:web) do
    within release_path do 
      execute "source #{shared_path}/.env && '#{release_path}/bin/build'"
    end
  end    
end  

task "copy_system_d_file" do
  on roles(:web) do
    execute "sudo cp #{release_path}/_build/prod/systemd/lib/systemd/system/my-hive.service /etc/systemd/system" 
    execute "sudo systemctl daemon-reload"
  end
end  

task "copy_ruby_files" do
  on roles(:web) do
    path = "#{fetch(:deploy_to)}/current/_build/prod/rel/my_hive"
    path2 = "#{fetch(:deploy_to)}/current/_build/prod/rel/my_hive/bin"
    execute "sudo mkdir -p #{path}"
    execute "sudo cp #{release_path}/Gemfile #{path}" 
    execute "sudo cp #{release_path}/Gemfile #{path}" 
    execute "sudo cp #{release_path}/lib/my_hive/blog/services/thumbnailer.rb #{path}" 

    execute "sudo cp #{release_path}/lib/my_hive/file_manager/document_provider/*.rb #{path}"
    execute "sudo cp #{release_path}/Gemfile #{path2}" 
    execute "sudo cp #{release_path}/lib/my_hive/blog/services/thumbnailer.rb #{path2}" 
    execute "sudo cp #{release_path}/lib/my_hive/file_manager/document_provider/*.rb #{path2}"
  end
end  

task "binstubs" do 
  on roles(:web) do
    execute "bundle install --binstubs --gemfile=#{fetch(:deploy_to)}/current/_build/prod/rel/my_hive/Gemfile --path=#{fetch(:deploy_to)}/current/_build/prod/rel/my_hive/.bundle"
  end  
end
task "copy_dicom_uploader" do
  on roles(:web) do
    execute "sudo cp -v #{release_path}/bin/UploadImages.py #{fetch(:deploy_to)}/current/_build/prod/rel/my_hive/bin"
  end
end  


task "copy_favicon" do 
  on roles(:web) do 
    execute "cp #{release_path}/priv/static/favicon.ico  #{release_path}/_build/prod/rel/my_hive/lib/my_hive-0.1.0/priv/static/favicon.ico"
  end
end

task "copy_swipe_skin" do 
  on roles(:web) do 
    execute "sudo mkdir -p #{release_path}/_build/prod/rel/my_hive/lib/my_hive-0.1.0/priv/static/css/images"
    execute "sudo cp #{release_path}/assets/images/default-skin.png  #{release_path}/_build/prod/rel/my_hive/lib/my_hive-0.1.0/priv/static/css/images"
  end
end
after "deploy:published", "deps_get"
after  "deps_get", "gen_system_d"
after "gen_system_d", "gen_deploy_files"
after "gen_deploy_files", "upload_build_script"
after "upload_build_script", "exec_build_script"
after "exec_build_script", "copy_system_d_file"
after "copy_system_d_file", "copy_ruby_files"
after "copy_ruby_files", "copy_dicom_uploader"
after "copy_dicom_uploader", "copy_favicon"
after "copy_favicon", "copy_swipe_skin"