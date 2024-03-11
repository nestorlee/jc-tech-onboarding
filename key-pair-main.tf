#####################
## Key Pair - Main ##
#####################

# Generates a secure private key and encodes it as PEM
resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Generate a random int for KP name
resource "random_integer" "priority" {
  min = 1
  max = 123
}

# Create the Key Pair
resource "aws_key_pair" "key_pair" {
  key_name   = "${local.initials}-JC-KP-${random_integer.priority.result}"  
  public_key = tls_private_key.key_pair.public_key_openssh
}

# Save file
resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.key_pair.key_name}.pem"
  content  = tls_private_key.key_pair.private_key_pem
}