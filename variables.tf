# variables.tf - declare variables and set a default value

variable "network" {
  default = "10.10"
}

variable "private_key_path" {
  default = ~/.ssh/xxxxxxxxx 
}
variable "public_key_path" {
  default = ~/.ssh/xxxxxxxxx.pub
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-2"
}

# Ubuntu Precise 20.04 LTS (x64)
# variable "aws_amis" {
#  default = {
#    us-west-1 = "ami-036e9fc1037b68e21"
#    us-west-2 = "ami-091fa45b154a839b0"
#    us-east-1 = "ami-0b21b141ea690ace5"
#    us-east-2 = "ami-0f1e3b53911c43417"
#  }
#}
