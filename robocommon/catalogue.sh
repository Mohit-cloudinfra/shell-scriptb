
source ./common.sh

check_root

app_setup "catalogue"

install_node

cp $SHELL_LOC/catalogue.service /etc/systemd/system/catalogue.service

reload

enable_start catalogue

cp $SHELL_LOC/mongo.repo /etc/yum.repos.d/mongo.repo


load_mongodb

restart catalogue

