# RDS port forwarding made easy
Shell script to access private RDS database via a jump host using AWS SSM

Usage:

`./ssm_rds_jump_host.sh --instance_id <instance_id> --port <port_to_forward_to> --rds_url <rds_db_url:port>`

Example: `./ssm_rds_jump_host.sh --instance_id i-xyz --port 10004 --rds_url rds-cool-db.exampleurl.us-east-1.rds.amazonaws.com:5432`

Use `Ctrl + C` to exit script 