pkgs     = %w{ libreadline-dev libncurses5-dev libpcre3-dev libssl-dev perl make build-essential }
dirs     = ['/var/log/nginx', '/etc/nginx/conf.d']
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
  not_if { Dir.exists?("#{node[:system][:installdir]}/openresty") }
end

directory "#{node[:system][:workdir]}" do
  recursive true
  action    :delete
end

dirs.each do |dir|
  directory dir do
    user      "nobody"
    group     "nobody"
    mode      0755
    recursive true
    action    :create
  end
end

template "/etc/nginx/nginx.conf" do
  source "nginx.conf"
  mode   644
  owner  "nobody"
  group  "nobody"
end

bash "add to path and start" do
  code <<-EOH
    echo 'PATH=/usr/local/openresty/nginx/sbin:$PATH' >> /root/.bash_profile
    echo 'export PATH' >> /root/.bash_profile
    #{node[:system][:installdir]}/openresty/nginx/sbin/nginx -p '#{node[:system][:installdir]}/openresty' -c /etc/nginx/nginx.conf
  EOH
end
