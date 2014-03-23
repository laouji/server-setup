extract_path = "/home/#{node[:pyenv][:user]}"

user "#{node[:pyenv][:user]}" do
    home "#{extract_path}"
    shell "/bin/bash"
    action :create
end

bash "install pyenv" do
    user "#{node[:pyenv][:user]}"
    cwd "#{extract_path}"
    environment 'HOME' => "/home/#{node[:pyenv][:user]}"
    code <<-EOH
        git clone git://github.com/yyuu/pyenv.git #{extract_path}/.pyenv
        echo 'export PYENV_ROOT="$HOME/.pyenv"' >> #{extract_path}/.bash_profile
        echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> #{extract_path}/.bash_profile
        echo 'eval "$(pyenv init -)"' >> #{extract_path}/.bash_profile
        source #{extract_path}/.bash_profile
        pyenv install 3.3.3
        pyenv rehash
    EOH
end
