php_packages = %w{ php-common php-cli php-pear }

php_packages.each do |pkg|
  package pkg do
    action :install
  end
end

ruby_block "insert_command" do
  block do
    file = Chef::Util::FileEdit.new("#{node[:php][:conf_file]}")
    configuration = node[:php][:configuration]
    configuration.each_pair do |k,v|
      file.search_file_replace_line(
        /#{k} = [0-9]*M?/,
        "#{k} = #{v}"
      )
    end
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
