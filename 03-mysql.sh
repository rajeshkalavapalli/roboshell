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

    dnf module disable mysql -y &>> $LOGFILE
    validation $? "disableing mysql"

    cp /home/centos/roboshell/mysql.repo /etc/yum.repos.d/mysql.repo &>> $LOGFILE
    validation $? "copying mysql"

    dnf install mysql-community-server -y &>> $LOGFILE
    validation $? "InstallING MySQL Server"

    systemctl enable mysqld &>> $LOGFILE
    validation $? "Enableing MySQL Server"

    systemctl start mysqld &>> $LOGFILE
    validation $? "starting MySQL Server"

    mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOGFILE
    validation $? "seting password"


fi
