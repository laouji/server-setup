base_packages = %w{
curl git libxml2 libxml2-devel man netstat-nat openssl openssl-devel
rsync telnet vim-enhanced wget unzip zip zlib zlib-devel
}

base_packages.each do |pkg|
    package pkg do
        action :install
    end
end
