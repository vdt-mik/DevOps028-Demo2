#!/bin/bash
sudo yum update -y && sudo yum install nano vim git -y
#======================================
# Install JDK
#
#cd /tmp && wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
#"http://download.oracle.com/otn-pub/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-linux-x64.rpm" && sudo yum localinstall jdk-8u*-linux-x64.rpm -y
sudo yum remove java -y
sudo yum install java-1.8.0-openjdk -y
#======================================
# Create user
#
sudo adduser app
sudo su app
#======================================
# Set AWS variables
#
function get_pr {
    aws ssm get-parameters --names $1 --with-decryption --output text | awk '{print $4}'
}

export AWS_DEFAULT_REGION=eu-central-1
export AWS_SECRET_ACCESS_KEY=`get_pr "access_key"`
export AWS_ACCESS_KEY_ID=`get_pr "key_id"`
#======================================
# Set DB variables
#
export DB_NAME=`get_pr "DB_NAME"`
export DB_USER=`get_pr "DB_USER"`
export DB_PASS=`get_pr "DB_PASS"`
export DB_HOST=`get_pr "DB_HOST"`
export DB_PORT=`get_pr "DB_PORT"`
export DB_INST_NAME=`get_pr "DB_INST_NAME"`
#======================================
# Create APP folder & download liquibase project setting from repo and jdbc_driver
#
mkdir -p ~/app && cd ~/app
aws s3 cp s3://mik-bucket/liquibase.tar.gz ~/app
tar xzf liquibase.tar.gz && cd liquibase
mkdir -p lib && cd lib && wget https://jdbc.postgresql.org/download/postgresql-42.1.4.jar
cd .. && cat <<EOF> liquibase.properties
driver: org.postgresql.Driver
url: jdbc:postgresql://$DB_HOST:$DB_PORT/$DB_NAME
username: $DB_USER
password: $DB_PASS
# specifies packages where entities are and database dialect, used for liquibase:diff command
referenceUrl=hibernate:spring:academy.softserve.aura.core.entity?dialect=org.hibernate.dialect.PostgreSQL9Dialect
EOF
#======================================
# Download binary file liquibase & run liqubase 
#
mkdir -p bin && cd bin && wget https://github.com/liquibase/liquibase/releases/download/liquibase-parent-3.5.3/liquibase-3.5.3-bin.tar.gz \
&& tar xzf liquibase-3.5.3-bin.tar.gz
./liquibase --classpath=../lib/postgresql-42.1.4.jar --changeLogFile=../changelogs/changelog-main.xml --defaultsFile=../liquibase.properties update
#======================================
# Download APP JAR file and run APP
#
aws s3 cp s3://mik-bucket/Samsara-1.3.5.RELEASE.jar ~/app && cd ~/app 
java -jar Samsara-1.3.5.RELEASE.jar &
#