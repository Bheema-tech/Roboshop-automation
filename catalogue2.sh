#!/bin/bash
source ./common.sh
app_name=catalogue

check_root
app_setup
nodejs_setup
systemd_setup

cp mongo.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-mongosh -y &>>$LOG_FILE 
VALIDATE $? "Mongodb client installation"

STATUS=$(mongosh --host mongodb.bheemadevops.fun --eval 'db.getMongo().getDBNames().indexOf("catalogue")')
if [ $STATUS -lt 0 ]
then
    mongosh --host mongodb.bheemadevops.fun </app/db/master-data.js &>>$LOG_FILE
    VALIDATE $? "Loading data into MongoDB"
else
    echo -e "Data is already loaded ... $Y SKIPPING $N"
fi

print_time