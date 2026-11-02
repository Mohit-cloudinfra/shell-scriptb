
USERID=$(id -u)
LOGS_FOLDER=/var/log/shell-roboshop-common
mkdir -p $LOGS_FOLDER
LOGS_FILE=$LOGS_FOLDER/$0.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
SHELL_LOC=$PWD
MONGO_IP=mongodb.mohitsai.cloud
MYSQL_IP=mysql.mohitsai.cloud



check_root(){
    if [ $USERID -ne 0 ]; then   
        echo -e "$R please use root user $N" | tee -a $LOGS_FILE
        exit 1
    fi
}

check(){
    if [ $1 -eq 0 ]; then
        echo -e "$2 -----> $G SUCCESS :) $N" | tee -a $LOGS_FILE
    else
        echo -e "$2 -----> $R FAILURE :( $N" | tee -a $LOGS_FILE
        exit 1
    fi
}

install(){
    for i in $@
    do
        dnf install $i -y &>>$LOGS_FILE
        check $? "Installing $i"
    done
}

enable_start(){
    systemctl enable $1 &>>$LOGS_FILE
    check $? "Enabling $1"
    systemctl start $1 &>>$LOGS_FILE
    check $? "Starting $1"
}

restart(){
    systemctl restart $1 &>>$LOGS_FILE
    check $? "Restarting $1"
}

install_certain(){
    dnf module disable $1 -y
    check $? "Disabling $1"

    dnf module enable $1:$2 -y
    check $? "Enabling $1 $2 version"

    install $1

}

install_node(){
	install_certain "nodejs" "20"
	cd /app
    npm install &>>$LOGS_FILE
    check $? "Installing node packages"

}

app_setup(){
    id roboshop &>>$LOGS_FILE
    if [ $? -ne 0 ]; then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOGS_FILE
        check $? "Creating roboshop user"
    fi

    mkdir -p /app
    check $? "App folder created"
    curl -o /tmp/$1.zip https://roboshop-artifacts.s3.amazonaws.com/$1-v3.zip &>>$LOGS_FILE
    check $? "Downloading $1 code"
    cd /app
    check $? "Moved to app folder"
    rm -rf /app/*
    check $? "Cleaned app folder"
    unzip /tmp/$1.zip &>>$LOGS_FILE
    check $? "Unzipping $1 code"
}


reload(){
    systemctl daemon-reload  &>>$LOGS_FILE
    check $? "Reloading "
}

load_mongodb(){
	install mongodb-mongosh
	mongosh --host $MONGO_IP </app/db/master-data.js
	check $? "Loading mongodb products"
}

install_java(){
	install "maven"
	cd /app
	mvn clean package
	mv target/shipping-1.0.jar shipping.jar
	check $? "Building shipping with maven"
}

load_sql(){
	install "mysql"
	mysql -h $MYSQL_IP -uroot -pRoboShop@1 < /app/db/schema.sql
	check $? "Loading schema"
	mysql -h $MYSQL_IP -uroot -pRoboShop@1 < /app/db/app-user.sql 
	check $? "Creating app user"
	mysql -h $MYSQL_IP -uroot -pRoboShop@1 < /app/db/master-data.sql
	check $? "Load master data"
}

rabbitmq_setup(){
	rabbitmqctl add_user roboshop roboshop123
	check $? "rabbitmq user add "
    rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
	check $? "rabbitmq set permissions"
}

install_python(){
	install "python3" "gcc" "python3-devel"
	cd /app
	pip3 install -r requirements.txt
	check $? "installing requrimetns"
}

nginx_setup(){
	rm -rf /usr/share/nginx/html/*
	check $? "removed default nginx"
	curl -o "/tmp/frontend.zip" "https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip" &>>$LOGS_FILE
	check $? "downloaded roboshop content"
	cd /usr/share/nginx/html 
	check $? "Moved to html in nginx"
	unzip "/tmp/frontend.zip" &>>$LOGS_FILE
	check $? "Unzipping frontend"
	cp $SHELL_LOC/nginx.conf /etc/nginx/nginx.conf
	check $? "Copying the required nginx configuration"
}