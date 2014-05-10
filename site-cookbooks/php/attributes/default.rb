default[:php][:conf_file]   = "/etc/php.ini"
default[:php][:configuration]   = { max_execution_time: 200, post_max_size: "200M", upload_max_filesize: "20M", max_file_uploads: 100 }
default[:php][:extension_dir]   = "/etc/php.d"
