php_packages = %w{ php-common php-cli php-pear php-mbstring php-gd php-pear-MDB2-Driver-mysqli php-fpm }

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

    file.search_file_replace_line(
      /cgi\.fix_pathinfo = [0-9]/,
      "cgi.fix_pathinfo = 0"
    )

    file.search_file_replace_line(
      /;error_log = syslog/,
      "error_log = syslog"
    )
    
    file.write_file
  end
end

file "#{node[:php][:extension_dir]}/zzz.ini" do
  owner "root"
  group "root"
  mode "644"
  content "extension=exif.so"
  action :create
end

bash "chkconfig --add" do
    code <<-EOH
        chkconfig --add php-fpm
        chkconfig php-fpm on
    EOH
    not_if "chkconfig --list | grep php-fpm | grep -q on"
end

bash "start" do
    code <<-EOH
        service php-fpm start
    EOH
    not_if "service php-fpm status"
end
