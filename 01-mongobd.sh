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

    cp /home/centos/roboshell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
    validation $? "coyping repo"


    dnf install mongodb-org -y  &>> $LOGFILE
    validation $? "installing mongo shell"

    systemctl enable mongod &>> $LOGFILE
    validation $? "enabling mongod"

    systemctl start mongod &>> $LOGFILE
    validation $? " starting  mongod"

    sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE
    validation $? " remote acces"

    systemctl restart mongod &>> $LOGFILE
    validation $? " restarting  mongod"


fi