# Terraform Launch AWS EC2 Instance Sample

This code creates a VPC and launches an Ubuntu EC2 instance on AWS. It also configures a security group that allows all traffic from `my_ip`.

`AWS_ACCESS_KEY_ID`and `AWS_SECRET_ACCESS_KEY` environment variables are required.

### Deployment

1. Install Terraform
3. Edit `my_ip` varible in `terraform.tfvars` file.
2. `terraform init`
3. `terraform plan`: previews changes to be applied
4. `terraform apply`
