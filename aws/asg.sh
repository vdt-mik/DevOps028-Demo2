#!/bin/bash
function get_pr {
    aws ssm get-parameters --names $1 --with-decryption --output text | awk '{print $4}'
}

#======================================
# Create LC
# 
if [[ "`aws autoscaling describe-launch-configurations --launch-configuration-names $(get_pr "LC_NAME") 2>/dev/null | wc -l`" != "3" ]]
then
echo "LC up!"
else
echo "LC down!!!"
echo "Starting create LC"
aws autoscaling create-launch-configuration --launch-configuration-name `get_pr "LC_NAME"` --key-name ec2-key --image-id ami-c7ee5ca8 \
--security-groups samsara-sg --instance-type t2.micro --user-data file://aws/user-data.sh --instance-monitoring Enabled=true --iam-instance-profile EC2
echo "LC created ===============================>"
fi

#======================================
# Create LB
#
if [[ "`aws elb describe-load-balancers --load-balancer-names $(get_pr "LB_NAME") 2>/dev/null | wc -l`" != "0" ]]
then
echo "LB up!"
else
echo "LB down!!!"
echo "Starting create LB"
aws elb create-load-balancer --load-balancer-name `get_pr "LB_NAME"` \
--listeners "Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=9000" --subnets subnet-13828169 --security-groups sg-835e8ee9
aws elb configure-health-check --load-balancer-name `get_pr "LB_NAME"` \
--health-check Target=HTTP:9000/login,Interval=5,UnhealthyThreshold=5,HealthyThreshold=2,Timeout=2
aws ssm put-parameter --name "APP_URL" --type "String" --value "$(aws elb describe-load-balancers --load-balancer-names \
`get_pr "LB_NAME"` | grep DNSName | awk '{print $2}' | cut -d'"' -f2)" --overwrite
echo "LB created ===============================>"
fi

#======================================
# Create ASG
#
if [[ "`aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names $(get_pr "ASG_NAME") 2>/dev/null | wc -l`" != "3" ]]
then
let NEW_SIZE=`get_pr "ASG_MAX_SIZE"`*2
echo "ASG up!"
echo "Create new instances"
aws autoscaling update-auto-scaling-group --auto-scaling-group-name `get_pr "ASG_NAME"` \
--termination-policies "OldestInstance" --max-size ${NEW_SIZE} --desired-capacity ${NEW_SIZE} 
sleep 120
echo "Kick old instances"
aws autoscaling update-auto-scaling-group --auto-scaling-group-name `get_pr "ASG_NAME"` --max-size `get_pr "ASG_MAX_SIZE"` --desired-capacity `get_pr "ASG_MAX_SIZE"`
else
echo "ASG down!!!"
echo "Starting create"
aws autoscaling create-auto-scaling-group --auto-scaling-group-name `get_pr "ASG_NAME"` \
--launch-configuration-name `get_pr "LC_NAME"` --min-size 1 --max-size `get_pr "ASG_MAX_SIZE"` --desired-capacity 1 \
--load-balancer-names `get_pr "LB_NAME"` --health-check-type ELB --health-check-grace-period 300 --availability-zones eu-central-1b
echo "ASG created ===============================>"
sleep 120
fi