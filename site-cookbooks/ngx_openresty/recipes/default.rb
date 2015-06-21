pkgs     = %w{ libreadline-dev libncurses5-dev libpcre3-dev libssl-dev perl make build-essential }
filename = "ngx_openresty-#{node[:openresty][:version]}"

pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

remote_file "#{node[:system][:local_lib]}/#{filename}.tar.gz" do
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
  cwd "#{node[:system][:local_lib]}"
  not_if { Dir.exists?("#{node[:system][:local_lib]}/#{filename}") }
end
