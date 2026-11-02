
source ./common.sh

check_root

install "mysql-server"

enable_start "mysqld"

mysql_secure_installation --set-root-pass RoboShop@1