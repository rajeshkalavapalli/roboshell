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
    
    mkdir /app &>> $LOGFILE
    validation $? "creating app directory"

    curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>> $LOGFILE
    validation $? "downloading code"

    cd /app &>> $LOGFILE
    validation $? "changing app directory"

    unzip /tmp/cart.zip &>> $LOGFILE
    validation $? "unzipping"
 
    npm install &>> $LOGFILE
    validation $? "installing dependencys"

    cp /home/centos/roboshell/cart.service /etc/systemd/system/cart.service &>> $LOGFILE
    validation $? "copying cart.service "

    systemctl daemon-reload &>> $LOGFILE
    validation $? "daemon-reload"

    systemctl enable cart &>> $LOGFILE
    validation $? "enableing cart"

    systemctl start cart &>> $LOGFILE
    validation $? "starting cart"

fi

