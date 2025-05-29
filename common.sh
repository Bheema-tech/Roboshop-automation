#!/bin/bash
START_TIME=$(date +%s)
USERD=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
LOGS_FOLDER="/var/logs/roboshop_logs"
SCRIPT_NAME=$(echo $0 | cut -d "." f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
SCRIPT_DIR=$PWD

echo "Script exeuction Start time: $START_TIME"
#log folder creation
#tee command used to same command output to be saved in log file, tee -a filename --> it will append to file, it will not overwrite
# &>> to append the end of the file
mkdir -p $LOGS_FOLDER
check_root(){
    if [ $USERID -ne 0 ]
       then
       echo -e "ERROR $R Please run the script with Root access$N" | tee -a $LOG_FILE
       exit 1
    else
       echo "%G Scriping is running with Root Access"
    f1
}

VALIDATE(){
    if [ $1 -eq 0 ]
       then
            echo -e "$2 is ... $G SUCCESS $N" | tee -a $LOG_FILE
        else
            echo -e "$2 is ----$R Failure $N" | tee -a $LOG_FILE
        exit 1
    f1
}

print_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(($END_TIME-$START_TIME))
    echo -e "$G Total time taken for scription Exeuction: tame taken in seconds$N:$TOTAL_TIME"
}
