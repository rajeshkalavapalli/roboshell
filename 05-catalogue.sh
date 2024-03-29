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

    dnf module disable nodejs -y
    validation $? "disable nodejs"

    dnf module enable nodejs:18 -y
    validation $? "enable nodejs:18"

    dnf install nodejs -y
    validation $? "installing nodejs:18"

    if [ $? -ne 0 ]
    then
        useradd roboshop
        validation $? "user adding "
    else
        echo -e "$Y already user exist $N"
    fi

    mkdir /app
    validation $? "creating app directory"

    curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip
    validation $? "code downloading to app directory"

    cd /app 
    validation $? "changing to app directory"

    unzip -o /tmp/catalogue.zip
    validation $? "unziping"

    npm install 
    validation $? "installing dependencys"

    cp /home/centos/roboshell/catalogue.service /etc/systemd/system/catalogue.service
    validation $? "copying catalogue service"

    systemctl daemon-reload
    validation $? "daemon-reloading"

    systemctl enable catalogue
    validation $? "enableing  catalogue"

    cp /home/centos/roboshell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
    validation $? "copying mongo db repo"

    dnf install mongodb-org-shell -y
    validation $? "installing mongoshell"

    mongo --host 172.31.90.46 </app/schema/catalogue.js
    validation $? "loading catalogue"

fi