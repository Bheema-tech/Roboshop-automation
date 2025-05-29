#!/bin/bash
START_TIME=$(date +%s)
USERD=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGS_FOLDER="/var/logs/roboshop_logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
SCRIPT_DIR=$PWD

echo "Script exeuction Start time: $START_TIME"
#log folder creation
#tee command used to same command output to be saved in log file, tee -a filename --> it will append to file, it will not overwrite
# &>> to append the end of the file
mkdir -p $LOGS_FOLDER
check_root(){
    if [ $USERD -ne 0 ]
    then
        echo -e "ERROR $R Please run the script with Root access$N" | tee -a $LOG_FILE
        exit 1
    else
        echo -e "Scriping is running with Root Access"
    fi
}

VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo -e "$2 is ...  $G  SUCCESS $N" | tee -a $LOG_FILE
    else
        echo -e "$2 is ---- $R Failure $N" | tee -a $LOG_FILE
        exit 1
    fi
}

app_setup(){
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
    fi
    curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip &>>$LOG_FILE 
    unzip /tmp/catalogue.zip
    VALIDATE $? "Unzipping the catalogue files"
    npm install &>>$LOG_FILE 
    VALIDATE $? "Dependcies installation"
}

nodejs_setup(){
    dnf module disable nodejs -y &>>$LOG_FILE 
    VALIDATE $? "Disabling default nodejs"
    dnf module enable nodejs:20 -y &>>$LOG_FILE 
    VALIDATE $? "enabling nodejs20"
    dnf install nodejs -y &>>$LOG_FILE 
    VALIDATE $? "Installing nodejs"
}

systemd_setup(){
    cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service
    VALIDATE $? "Copying catalogue service"
    systemctl daemon-reload &>>$LOG_FILE 
    systemctl enable catalogue &>>$LOG_FILE 
    systemctl start catalogue &>>$LOG_FILE 
    VALIDATE $? "Starting Catalogue"

}

print_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(($END_TIME-$START_TIME))
    echo -e "$R Total time taken for scription Exeuction:$Y tame taken in seconds$N:$TOTAL_TIME"
}
