

source ./common.sh

check_root

install_certain "nginx" "1.24"

enable_start "nginx"

nginx_setup

restart nginx