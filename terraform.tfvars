# terraform.tfvars - set the actual values in the variables
key_name        = "terraform-radarblip"
public_key_path = "~/.ssh/terraform-radarblip.pub"

aws_access_key = "XXXXXXXXXXXXXXXXXXXX"
aws_secret_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
aws_key_path = "~/.ssh/radarblip.pem"
aws_key_name = "radarblip"
aws_region = "us-east-2"
network = "10.10"

# These most often come from terraform-aws-vpc, but can be manually set
# if you don't want to or can't use that module.
aws_route_table_private_id = "X"
aws_internet_gateway_id = "X"
aws_route_table_public_id = "X"
aws_vpc_id = "X"
