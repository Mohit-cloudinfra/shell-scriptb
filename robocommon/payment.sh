
source ./common.sh

check_root

app_setup "payment"

install_python

cp $SHELL_LOC/payment.service /etc/systemd/system/payment.service

reload

enable_start "payment"