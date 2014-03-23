extract_path = "/home/#{node[:plenv][:user]}"

user "#{node[:plenv][:user]}" do
    home "#{extract_path}"
    shell "/bin/bash"
    action :create
end

bash "install plenv" do
    user "#{node[:plenv][:user]}"
    cwd "#{extract_path}"
    environment 'HOME' => "/home/#{node[:plenv][:user]}"
    code <<-EOH
        git clone git://github.com/tokuhirom/plenv.git #{extract_path}/.plenv
        echo 'export PATH="#{extract_path}/.plenv/bin:$PATH"' >> #{extract_path}/.bash_profile
        echo 'eval "$(plenv init -)"' >> #{extract_path}/.bash_profile
        source #{extract_path}/.bash_profile
        git clone git://github.com/tokuhirom/Perl-Build.git #{extract_path}/.plenv/plugins/perl-build/
        plenv install #{node[:plenv][:perl_ver]}
        plenv rehash
    EOH
end
