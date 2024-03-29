#!/bin/bash 

ID=$(id -u)

TIMESTAMP=$(date +%F-%m-%S)

LOGFILE=/tmp/$0-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"



validation(){

    if [ $1 -ne 0 ]
then 
    echo -e "$R $2 ...........failed $N"
else
    echo -e "$G $2............success $N"

fi
}

if [ $ID -ne 0 ]
then 
    echo -e " $R please run this script with root user $N"
    exit 1
else
    echo -e "$G you're a root user $N"

    curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
    validation $? "cheking script provided by vendor"

    curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash
    validation $? "Configure YUM Repos for RabbitMQ"

    dnf install rabbitmq-server -y 
    validation $? "installing  RabbitMQ"

    systemctl enable rabbitmq-server 
    validation $? "enabling RabbitMQ-server"

    systemctl start rabbitmq-server 
    validation $? "starting RabbitMQ-server"

    rabbitmqctl add_user roboshop roboshop123
    validation $? "useradding RabbitMQ-server"

    rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
    validation $? "permision RabbitMQ-server"
    

fi