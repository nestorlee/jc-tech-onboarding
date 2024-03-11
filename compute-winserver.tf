
resource "aws_network_interface" "jc_winserverdc_nwi" {
  subnet_id   = aws_subnet.jc_public_subnet.id

  tags = {
    Name        = "${local.initials}-JC-WinServerDC-NWI"
    Environment = "TF spun environment for JC - ${var.firstname} ${var.lastname}"
  }
}

resource "aws_network_interface_sg_attachment" "jc_winserverdc_nwi_attachment" {
  security_group_id    = aws_security_group.jc_sg.id
  network_interface_id = aws_network_interface.jc_winserverdc_nwi.id
}

resource "aws_eip" "jc_winserverdc_eip" {
  domain = "vpc"
  instance = aws_instance.jc_winserverdc.id
}

data "aws_ami" "windows" {
  most_recent = true
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["801119661308"]
}

resource "aws_instance" "jc_winserverdc" {
    ami = data.aws_ami.windows.id
    instance_type = "t3.small"
    key_name = aws_key_pair.key_pair.key_name
    get_password_data = "true"

    network_interface {
        network_interface_id = aws_network_interface.jc_winserverdc_nwi.id
        device_index = 0
    }

user_data = <<EOF
<powershell>
Rename-Computer -NewName ${local.windowServerName}
Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).ifIndex -ServerAddresses ($private_ip,"8.8.8.8")
shutdown /r /t 0
</powershell>
EOF
    tags = {
        Name        = "${local.windowServerName}"
        Environment = "TF spun environment for JC - ${var.firstname} ${var.lastname}"
    }
}
