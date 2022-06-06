#!/bin/bash

function usage(){
    echo "$(basename $0) [-i | --instance_id] [ -p | --port] [-u | --rds_url]"
}

function exit_script(){
    echo "*****Error in file $0 while processing task: $1 ******"
    exit 1
}

bastion_instance_id=
rds_db_url=
port_to_forward=


while [[ "$1" != "" ]]; do
    case $1 in
        -i | --instance_id )
        bastion_instance_id=$2;
        shift;
        ;;
        -p | --port )
        port_to_forward=$2;
        shift;
        ;;
        -u | --rds_url )
        rds_db_url=$2;
        shift;
        ;;                            
        -h | --help )
        usage;
        exit;
        ;;
    esac
    shift
done


# Use run command to port forward from rds to ec2
sh_command_id=$(aws ssm send-command \
    --document-name "AWS-RunShellScript" \
    --instance-ids $bastion_instance_id \
    --parameters '{"commands":["sudo yum install -y socat","sudo socat TCP-LISTEN:'$port_to_forward',reuseaddr,fork TCP4:'$rds_db_url'"]}' \
    --output text \
    --query "Command.CommandId")

echo "COMMAND ID: $sh_command_id"

# Print run command status
aws ssm list-command-invocations \
--instance-id $bastion_instance_id \
--command-id "$sh_command_id" \
--details --no-cli-pager || exit_script "Error while performing ssm send-command"


# Port forward to host/local machine
aws ssm start-session --target $bastion_instance_id --document-name AWS-StartPortForwardingSession --parameters '{"portNumber":['\"$port_to_forward\"'], "localPortNumber":['\"$port_to_forward\"']}' || exit_script "Error port forwarding to local"


# Cleanup: Stop RDS-EC2 port forward command 
aws ssm cancel-command \
    --command-id "$sh_command_id" \
    --instance-ids "$bastion_instance_id"


# Print run command status
aws ssm list-command-invocations \
--instance-id $bastion_instance_id \
--command-id "$sh_command_id" \
--details --no-cli-pager