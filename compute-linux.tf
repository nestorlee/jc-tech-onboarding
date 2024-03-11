
resource "aws_network_interface" "jc_linux_nwi" {
  subnet_id   = aws_subnet.jc_public_subnet.id

  tags = {
    Name        = "${local.initials}-JC-Linux-NWI"
    Environment = "TF spun environment for JC - ${var.firstname} ${var.lastname}"
  }
}

resource "aws_network_interface_sg_attachment" "jc_linux_nwi_attachment" {
  security_group_id    = aws_security_group.jc_sg.id
  network_interface_id = aws_network_interface.jc_linux_nwi.id
}

resource "aws_eip" "jc_linux_eip" {
  domain = "vpc"
  instance = aws_instance.jc_linux_server.id
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "jc_linux_server" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    key_name = aws_key_pair.key_pair.key_name

    network_interface {
        network_interface_id = aws_network_interface.jc_linux_nwi.id
        device_index = 0
    }

user_data = <<EOF
#!/bin/bash
DEBIAN_FRONTEND=noninteractive apt-get -y update
DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
DEBIAN_FRONTEND=noninteractive apt-get install net-tools -y
EOF

    tags = {
        Name        = "${local.initials}-JC-EC2-Linux"
        Environment = "TF spun environment for JC - ${var.firstname} ${var.lastname}"
    }
}
