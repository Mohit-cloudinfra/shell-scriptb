
source ./common.sh

check_root

cp $SHELL_LOC/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo

install "rabbitmq-server"

enable_start "rabbitmq-server"

rabbitmq_setup