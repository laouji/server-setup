mysql_packages = %w{ mysql mysql-devel mysql-server }

mysql_packages.each do |pkg|
  package pkg do
    action :install
  end
end

directory "#{node[:mysql][:conf_include_dir]}" do
  owner "root"
  group "root"
  mode 644
  action :create
end

template "#{node[:mysql][:conf_include_dir]}/encoding.cnf" do
  source "encoding.cnf"
  mode 644
  owner "root"
  group "root"
end

ruby_block "insert_command" do
  block do
    file = Chef::Util::FileEdit.new("#{node[:mysql][:conf_file]}")
    file.insert_line_if_no_match(
        /!includedir \/etc\/mysql\.d/,
    "!includedir /etc/mysql.d"
    )
    file.write_file
  end
end

bash "chkconfig --add" do
  code <<-EOH
    chkconfig --add mysqld
    chkconfig mysqld on
  EOH
  not_if "chkconfig --list | grep mysqld | grep on"
end

bash "start" do
  code <<-EOH
    service mysqld start
  EOH
  not_if "service mysqld status"
end
