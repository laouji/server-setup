pkgs     = %w{ libreadline-dev libncurses5-dev libpcre3-dev libssl-dev perl make build-essential }
filename = "ngx_openresty-#{node[:openresty][:version]}"

pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

directory "#{node[:system][:workdir]}" do
  user   "root"
  group  "root"
  action :create
end

remote_file "#{node[:system][:workdir]}/#{filename}.tar.gz" do
  source "#{node[:openresty][:tarball_path]}"
  action :create_if_missing
end

bash "make install" do
  code <<-EOH
    tar -xzvf #{filename}.tar.gz
    chown -R dkr:dkr #{filename}/
    cd #{filename}/
    ./configure --with-pcre-jit --with-ipv6
    make
    make install
  EOH
  cwd "#{node[:system][:workdir]}"
  not_if { Dir.exists?("#{node[:system][:local_lib]}/openresty") }
end

bash "modify permissions" do
  code <<-EOH
    chown -R dkr:dkr #{node[:system][:local_lib]}/openresty
  EOH
end

directory "#{node[:system][:workdir]}" do
  recursive true
  action    :delete
end
