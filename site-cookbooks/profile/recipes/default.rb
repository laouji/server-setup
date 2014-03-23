template "/etc/profile.d/custom.sh" do
    source "custom.sh"
    mode 0644
    owner "root"
    group "root"
    action :create_if_missing 
end
