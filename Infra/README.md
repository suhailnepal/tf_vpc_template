# Infra
This folder will have all the configuration file for the infra.

## Key points:

* Default region is set to 'ap-southeast-2', change this as per your requirement.


## Steps Required to get this working

* Create an IAM user in AWS account with right permission to create VPC (it's dependecies), EC2 instances and RDS.
* Setup AWS CLI on your local machine, it's always a good practice to use a separate profile for terraform user. You will need to change this value in terraform.tfvars file.
* Make the following changes on state.tf file: 
    * In Line 7, change bucket name as per your requirement (Bucket name in AWS should be global)
    * Run Terraform apply, this will create KMS key, S3 bucket and Dynamo DB table.
* 
