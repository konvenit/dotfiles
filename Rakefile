require 'rake'

desc "install the dot files into user's home directory"
task :install do
  %x{touch ~/.bashrc_local}
  %x{chmod +x set_links}
  %x{./set_links}
end

desc "update the dot files form the repo"
task :update do
  puts %x{git pull --rebase}
end