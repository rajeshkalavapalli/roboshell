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

    dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOGFILE
    validation $? "repo for access"

    dnf module enable redis:remi-6.2 -y  &>> $LOGFILE
    validation $? "enableing redis"

    dnf install redis -y &>> $LOGFILE
    validation $? "installing redis"

    sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf &>> $LOGFILE
    validation $? "allowing remote connection"

    systemctl enable redis &>> $LOGFILE
    validation $? "enableing redis"

    systemctl start redis &>> $LOGFILE
    validation $? "sstarting redis"
fi


 
