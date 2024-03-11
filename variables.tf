variable "aws_region" {
  default = "us-west-1"
}

variable "aws_profile" {
    default = "default"
}

variable "firstname"{
    default = "Sales"
}

variable "lastname"{
    default = "Engineering"
}

variable "public_ssh_key" {
    default = ""
}

locals{
    initials = join("", [substr(var.firstname,0,1), substr(var.lastname,0,1)])
    windowServerName = format("%s%s",local.initials,"-JC-WinDC")
}