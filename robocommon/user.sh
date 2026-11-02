

source ./common.sh

check_root

install_certain "nodejs" "20"

app_setup "user"

install_node

cp /$SHELL_LOC/user.service /etc/systemd/system/user.service

reload

enable_start user
