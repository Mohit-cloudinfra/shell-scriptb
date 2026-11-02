
source ./common.sh

check_root

cp $SHELL_LOC/mongo.repo /etc/yum.repos.d/mongo.repo 
check $? "Copying mongo repo"

install "mongodb-org"

enable_start "mongod"

#i refered the mongodb,sh for this sed command i didnt remember it
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>$LOGS_FILE
check $? "Allowing remote connections"

restart "mongod"


 
