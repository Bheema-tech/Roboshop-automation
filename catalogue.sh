#!/bin/bash
souce ./common.sh
check_root
dnf module disable nodejs -y &>>$LOG_FILE 
VALIDATE $? "Disabling default nodejs"
dnf module enable nodejs:20 -y &>>$LOG_FILE 
VALIDATE $? "enabling nodejs20"
dnf install nodejs -y &>>$LOG_FILE 
VALIDATE $? "Installing nodejs"
mkdir -p /app
VALIDATE $? "creaing direcgtory"
cd /app
rm -rf /app *
id roboshop
if [$? -ne 0]
then
    useradd --system --home /app --shell /sbin/nolgin --comment "roboshop project purpose" roboshop
    VALIDATE $? "Creating roboshop system user"
else
    echo -e "Roboshop user id already created:$Y skipping it $N"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip &>>$LOG_FILE 
unzip /tmp/catalogue.zip
VALIDATE $? "Unzipping the catalogue files"
npm install &>>$LOG_FILE 
VALIDATE $? "Dependcies installation"
cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service
VALIDATE $? "Copying catalogue service"
systemctl daemon-reload &>>$LOG_FILE 
systemctl enable catalogue &>>$LOG_FILE 
systemctl start catalogue &>>$LOG_FILE 
VALIDATE $? "Starting Catalogue"
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