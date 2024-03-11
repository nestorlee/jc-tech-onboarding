
variable "vpc_cidr" {
  default     = "192.168.123.0/24"
  description = "CIDR block of the vpc"
}

variable "public_subnets_cidr" {

  default     = "192.168.123.0/26"
  description = "CIDR block for Public Subnet"
}


locals{
    random_cidr = join("", [substr(var.firstname,0,1), substr(var.lastname,0,1)])
}