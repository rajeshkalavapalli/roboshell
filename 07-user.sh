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
        useradd roboshop &>> $LOGFILE
        validation $? "user adding "
    else
        echo -e "$G already user exist$N $Y.........skipping $N"
    fi
    
    mkdir /app &>> $LOGFILE
    validation $? "creating app directory"

    curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>> $LOGFILE
    validation $? "code downloading"

    cd /app &>> $LOGFILE
    validation $? "changing  app directory"

    npm install &>> $LOGFILE
    validation $? "installing depencencys"

    systemctl daemon-reload &>> $LOGFILE
    validation $? "daemon-reloadig"

    systemctl enable user &>> $LOGFILE
    validation $? "enableing user"

    systemctl start user &>> $LOGFILE
    validation $? "starting user"

    cp /home/centos/roboshell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
    validation $? "mongodb repo copying"

    dnf install mongodb-org-shell -y &>> $LOGFILE
    validation $? "mongo db shell installing "

    mongo --host 172.31.90.46 </app/schema/user.js &>> $LOGFILE
    validation $? "loading schema"
fi







