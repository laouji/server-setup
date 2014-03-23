package "python-pip" do
    action :install
end

bash "pip supervisor" do
    code <<-EOH
        pip install supervisor
    EOH
end

bash "setup conf" do
    code <<-EOH
        echo_supervisord_conf > /etc/supervisord.conf
        mkdir /etc/supervisord.d/
        echo "[include]" >> /etc/supervisord.conf
        echo "files = /etc/supervisord.d/*.conf" >> /etc/supervisord.conf
    EOH
end

template "/etc/init.d/supervisord" do
    source "init_d"
    mode 0755
    owner "root"
    group "root"
end

bash "chkconfig --add" do
  code <<-EOH
    chkconfig --add supervisord
    chkconfig supervisord on
    service supervisord start
  EOH
  not_if "service supervisord status"
end
