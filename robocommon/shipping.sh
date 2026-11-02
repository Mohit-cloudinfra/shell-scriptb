
source ./common.sh

check_root

app_setup "shipping"

install_java

cp $SHELL_LOC/shipping.service /etc/systemd/system/shipping.service

reload

enable_start "shipping"

load_sql

restart "shipping"