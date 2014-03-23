package "nginx" do
    action :install
    options("--enablerepo=epel")
end

template "/etc/nginx/nginx.conf" do
    source "nginx.conf"
    mode 644
    owner "root"
    group "root"
end

bash "chkconfig --add" do
    code <<-EOH
        chkconfig --add nginx
        chkconfig nginx on
    EOH
    not_if "chkconfig --list | grep nginx | grep -q on"
end

bash "start" do
    code <<-EOH
        service nginx start
    EOH
    not_if "service nginx status"
end
