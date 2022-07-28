# RDS port forwarding made easy
Shell script to access private RDS database via a jump host using AWS SSM

Usage:

`./ssm_rds_jump_host.sh --instance_id <bastion_instance_id> --port <port_to_forward_to> --rds_url <rds_db_url:port>`

Example: `./ssm_rds_jump_host.sh --instance_id i-xyz --port 10004 --rds_url rds-cool-db.exampleurl.us-east-1.rds.amazonaws.com:5432`

Use `Ctrl + C` to exit script 


## EC2 DB port forwarding
`aws ssm start-session --region <region> --target <ec2_instance_id> --document-name AWS-StartPortForwardingSession --parameters '{"portNumber":["5432"],"localPortNumber":["10005"]}'`

Example: 
`aws ssm start-session --region us-east-1 --target i-123456789 --document-name AWS-StartPortForwardingSession --parameters '{"portNumber":["5432"],"localPortNumber":["10005"]}'`

