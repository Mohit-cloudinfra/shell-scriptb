

source ./common.sh

check_root

app_setup "cart"

install_node

cp $SHELL_LOC/cart.service /etc/systemd/system/cart.service

reload

enable_start cart
