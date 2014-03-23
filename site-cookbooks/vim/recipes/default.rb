package "vim-enhanced" do
    action :install
end

template "/root/.vimrc" do
    source "vimrc"
    mode 0644
    owner "root"
    group "root"
    action :create_if_missing 
end
