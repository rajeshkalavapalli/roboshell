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

    dnf module disable nodejs -y &>> $LOGFILE
    validation $? "disable nodejs"

    dnf module enable nodejs:18 -y &>> $LOGFILE
    validation $? "enable nodejs:18"

    dnf install nodejs -y &>> $LOGFILE
    validation $? "installing nodejs:18"

    if [ $? -ne 0 ]
    then
        useradd roboshop
        validation $? "user adding "
    else
        echo -e "$G already user exist$N $Y.........skipping $N"
    fi
    if [ $? -ne 0 ]
    then 
    mkdir -p /app &>> $LOGFILE
    validation $? "creating app directory"
    else
    echo -e "$Y alreay app directry existing $N"
    fi

    curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE
    validation $? "code downloading to app directory"

    cd /app  &>> $LOGFILE
    validation $? "changing to app directory"

    unzip -o /tmp/catalogue.zip &>> $LOGFILE
    validation $? "unziping"

    cd /app  &>> $LOGFILE
    validation $? "changing to app directory"

    npm install &>> $LOGFILE
    validation $? "installing dependencys"

    cp /home/centos/roboshell/catalogue.service /etc/systemd/system/catalogue.service &>> $LOGFILE
    validation $? "copying catalogue service"

    systemctl daemon-reload &>> $LOGFILE
    validation $? "daemon-reloading"

    systemctl enable catalogue &>> $LOGFILE
    validation $? "enableing  catalogue"

    cp /home/centos/roboshell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
    validation $? "copying mongo db repo"

    dnf install mongodb-org-shell -y &>> $LOGFILE
    validation $? "installing mongoshell"

    mongo --host mongodb.bigmatrix.in </app/schema/catalogue.js &>> $LOGFILE
    validation $? "loading catalogue"

fi