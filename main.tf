provider "aws"{
  region = var.aws_region
  profile = var.aws_profile
}


##########

output "winserver_password"{
    value = rsadecrypt(aws_instance.jc_winserverdc.password_data, file(resource.local_file.ssh_key.filename)) 
}


output "winserver_pip"{
    description = "Public IP Address of Windows server"
    value = aws_eip.jc_winserverdc_eip.public_ip
}


output "pip_linux"{
    description = "Public IP Address of Linux server"
    value = aws_eip.jc_linux_eip.public_ip
}
