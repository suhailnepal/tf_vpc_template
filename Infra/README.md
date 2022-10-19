# Infra
This folder will have all the configuration file for the infra.

## Key points:

* Default region is set to 'ap-southeast-2', change this as per your requirement.
* CIDR range used for the VPC is `10.50.0.0/16`, check variables.tf for more information.  
* Please follow the steps below in sequence to initliase Terraform and setup your Infrastructure. After each step, you will need to run terraform plan/apply before you move on the next step. 


## Step 1 (Setup Remote State)

* Create an IAM user in AWS account with right permission to create VPC (it's dependecies), EC2 instances and RDS.
* Setup AWS CLI on your local machine, it's always a good practice to use a separate profile for terraform user. You will need to change this value in terraform.tfvars file.
* Make the following changes on state.tf file: 
    * In Line 7, change bucket name as per your requirement (Bucket name in AWS should be global)
    * Run Terraform apply, this will create KMS key, S3 bucket and Dynamo DB table.
* Now add the remaining component in Backend S3 component in state.tf, will let you figure this out :-) . Once done, run terraform init (You will need to confirm this step, type `yes` to confirm) and the backend will be initiliased in the remote s3 bucket which you had created in the earlier step.
* Once initiliased, you will get a message `Successfully configured the backend "s3"!`

## Step 2 ()

* We will start by creating VPC (vpc.tf), in this demo, we are using public [module](https://github.com/terraform-aws-modules/terraform-aws-vpc). Check the module version and use the latest on the config file.
* Now deploy EC2 instance using ec2_nginx.tf configuration file. Comment out the security rule for the instance, it needs to be deployed after ALB is created.