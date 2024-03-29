#!/bin/bash 

ID=$(id -u)


validation(){

    if [ $1 -ne 0 ]
then 
    echo -e "$2 ...........failed"
else
    echo -e "$2............success"

fi
}

if [ $ID -ne 0 ]
then 
    echo -e "please run this script with root user"
    exit 1
else
    echo -e "you're a root user"

    cp /home/centos/roboshell/mongo.repo /etc/yum.repos.d/mongo.repo
    validation $? "coyping repo"


    dnf install mongodb-org -y 
    validation $? "installing mongo shell"

    systemctl enable mongod
    validation $? "enabling mangod"

    systemctl start mongod
    validation $? " starting  mangod"

    sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf 
    validation $? " remote acces"

    systemctl restart mongod
    validation $? " restarting  momgod"


fi