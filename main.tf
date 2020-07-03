# main.tf
terraform {
  required_version = ">= 0.12"
}

# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

# Create a VPC to launch our instances into
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_radar_instance" "radarblip" {
  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  connection {
    # The default username for our AMI
    user = "ubuntu"
    host = "${self.public_ip}"
    # The connection will use the local SSH agent for authentication.
  }

  instance_type = "t2.micro"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.aws_amis, var.aws_region)}"

  # The name of our SSH keypair we created above.
  key_name = "${aws_key_pair.auth.id}"

  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  # We're going to launch into the same subnet as our ELB. In a production
  # environment it's more common to have a separate private subnet for
  # backend instances.
  subnet_id = "${aws_subnet.default.id}"

  # We run a remote provisioner on the instance after creating it.
  # In this case, we just install nginx and start it. By default,
  # this should be on port 80
  provisioner "remote-exec" {
    inline = [
      # install nginx
      "sudo apt-get -y update"ls
      "sudo amazon-linux-extras enable nginx1.12"
      "sudo apt-get -y install nginx"
      "sudo systemctl start nginx"
      # install nodejs
      "sudo curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -""
      "sudo apt-get install -y nodejs"
      "sudo apt-get install npm"
      # install node-red
      "sudo npm install -g --unsafe-perm node-red node-red-admin"
      # make node-red startup on reboot
      "sudo npm install -g --unsafe-perm pm2"
      "sudo pm2 start `which node-red` -- -v"
      "sudo pm2 save"
      "sudo pm2 startup"
      "sudo ufw allow 1880"
      "sudo ufw allow 18800"
      "sudo cp ~/.node-red/settings.js ~/.node-red/settings.js.bak"
      "sudo sed -i 's/1880/18800/g' ~/.node-red/settings.js"
      "sudo node-red-admin target http://localhost:18800"
      "sudo node-red"
      # clone the radarblip node-red flows
      ""
      "sudo git clone https://github.com/surfd4wg/radarblip.git"
    ]
  }
}

resource "aws_eip" "ip" {
    vpc = true
    instance = aws_instance.example.id
}
resource "aws_security_group" "radargroup" {
	name = "radar-${var.offset}-${var.aws_vpc_id}"
	description = "radar security groups"
	vpc_id = "${var.aws_vpc_id}"

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		from_port = 443
		to_port = 443
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		cidr_blocks = ["0.0.0.0/0"]
		from_port = 1880
		to_port = 1880
		protocol = "tcp"
	}
	
	ingress {
		cidr_blocks = ["0.0.0.0/0"]
		from_port = 18800
		to_port = 18800
		protocol = "tcp"
	}

	ingress {
		cidr_blocks = ["0.0.0.0/0"]
		from_port = -1
		to_port = -1
		protocol = "icmp"
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags {
		Name = "radar-${var.offset}-${var.aws_vpc_id}"
	}

}
