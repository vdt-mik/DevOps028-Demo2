#!/bin/bash
#======================================
# Create RDS instance
#
function get_pr {
    aws ssm get-parameters --names $1 --with-decryption --output text | awk '{print $4}'
}

if [[ "`aws rds describe-db-instances --db-instance-identifier $(get_pr "DB_INST_NAME") 2>/dev/null | wc -l`" != "0" ]]
then
echo "RDS up!"
else
echo "RDS down!!!"
echo "Starting create RDS"
aws rds create-db-instance --db-instance-identifier `get_pr "DB_INST_NAME"` --allocated-storage 5 --db-instance-class db.t2.micro --engine postgres \
--master-username `get_pr "DB_USER"` --master-user-password `get_pr "DB_PASS"` --storage-type gp2 --backup-retention-period 0 --db-name `get_pr "DB_NAME"`

#======================================
# Checking create DB
#
TARGET_STATUS=available
STATUS=unknown
while [[ "$STATUS" != "$TARGET_STATUS" ]]; do
        STATUS=`aws rds describe-db-instances --db-instance-identifier $(get_pr "DB_INST_NAME") | grep DBInstanceStatus | awk '{print$2}' | cut -d'"' -f2`
        echo "Database $INSTANCE : $STATUS ... "
        sleep 15
done

#======================================
# Set DB variables
#
EXISTING_DB_INSTANCE_INFO=`aws rds describe-db-instances --db-instance-identifier $(get_pr "DB_INST_NAME") \
--query 'DBInstances[*].[DBInstanceIdentifier,Endpoint.Address,Endpoint.Port]' --output text`
aws ssm put-parameter --name "DB_HOST" --type "String" --value "$(echo ${EXISTING_DB_INSTANCE_INFO} | awk '{print $2}')" --overwrite
aws ssm put-parameter --name "DB_PORT" --type "String" --value "$(echo ${EXISTING_DB_INSTANCE_INFO} | awk '{print $3}')" --overwrite
fi