terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Django_WEB_Site_VPC"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "main_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "eu-central-1a"
  map_public_ip_on_launch = true
  
  depends_on = [aws_internet_gateway.gw]

  tags = {
    Name = "Django_WEB_Site_subnet"
  }
}

resource "aws_default_route_table" "example" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "example"
  }
}

resource "aws_security_group" "allow_tls_ssh_http" {
  name        = "allow_tls"
  description = "Allow TLS, SSH, HTTP inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls_ssh_http"
  }

}

resource "random_password" "password" {
  length = 8
  special = true
}

# create an instance
resource "aws_instance" "app_server" {
  ami             = lookup(var.amis, var.region)
  instance_type   = var.instanceType
  key_name        = var.keyName 
  private_ip      = "10.0.0.12"
  subnet_id       = aws_subnet.main_subnet.id
  #security_groups = aws_security_group.allow_tls_ssh_http.name # aws_security_group.allow_tls_ssh_http.id  #var.securityGroups
  vpc_security_group_ids = ["${aws_security_group.allow_tls_ssh_http.id}"] #aws_vpc.main.id # aws_security_group.allow_tls_ssh_http.id

 # Let's create and attach an ebs volume 
  # when we create the instance
  ebs_block_device {
    device_name = "/dev/xvdb"
    volume_type = "gp2"
    volume_size = 8 
  }

  credit_specification {
    cpu_credits = "unlimited"
  }

  # Name the instance
  tags = {
    Name = var.instanceName
  }

  # Name the volumes; will name all volumes included in the 
  # ami and the ebs block device from above with this instance.
  volume_tags = {
    Name = var.instanceName
  }

#  os_profile {
#    computer_name = "hostname"
#    admin_username = "testadmin"
#    admin_password = random_password.password.result
#  }
#  os_profile_linux_config {
#    disable_password_authentication = false
#  }
    # Copy in the bash script we want to execute.
  # The source is the location of the bash script
  # on the local linux box you are executing terraform
  # from.  The destination is on the new AWS instance.

  provisioner "file" {
    
  connection {
    type     = "ssh"
    user     = "ubuntu"
    password = ""
    private_key = file(var.keyPath)
    host     = self.public_ip
  }
    source      = "env_configuration_2.sh"
    destination = "/tmp/env_configuration_2.sh"
  }

    # Change permissions on bash script and execute from ec2-user.
  provisioner "remote-exec" {
  connection {
    type     = "ssh"
    user     = "ubuntu"
    password = ""        #random_password.password.result
    private_key = file(var.keyPath)
    host     = self.public_ip
  }
    inline = [
      "chmod +x /tmp/env_configuration_2.sh",
      "sudo bash /tmp/env_configuration_2.sh",
    ]
  }

    # Login to the ec2-user with the aws key.
#  connection {
#    type        = "ssh"
#    user        = "ubuntu"
#    password    = ""
#    private_key = file(var.keyPath)
#    host        = self.public_ip
#  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> local.txt"
  }

}

#resource "aws_network_interface_sg_attachment" "sg_attachment" {
#  security_group_id    = aws_security_group.allow_tls_ssh_http.id
#  network_interface_id = aws_instance.app_server.primary_network_interface_id
#}

output "public_ip" {
  value = aws_instance.app_server.public_ip
}



# resource "aws_vpc" "main" {
#   cidr_block       = "10.0.0.0/16"
#   instance_tenancy = "default"

#   tags = {
#     Name = "main"
#   }
# }

  # route {
  #   ipv6_cidr_block        = "::/0"
  #   egress_only_gateway_id = aws_egress_only_internet_gateway.example.id
  # }

# resource "default_route_table_id" "main" {
#   vpc_id = aws_vpc.main.id
#   default_route_table_id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.gw.id
#   }

# resource "aws_route_table" "example" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.gw.id
#   }

# resource "aws_main_route_table_association" "a" {
#   vpc_id         = aws_vpc.main.id
#   route_table_id = aws_route_table.example.id
# }

  # route {
  #   ipv6_cidr_block        = "::/0"
  #   egress_only_gateway_id = aws_egress_only_internet_gateway.main.id
  # }

#   tags = {
#     Name = "example"
#   }
# }

# resource "aws_internet_gateway_attachment" "example" {
#   internet_gateway_id = aws_internet_gateway.gw.id
#   vpc_id              = aws_vpc.main.id
# }

# resource "aws_network_interface" "main_interface" {
#   subnet_id   = aws_subnet.main_subnet.id
#   private_ips = ["10.0.0.50"]

#   tags = {
#     Name = "Django_WEB_Site_primary_network_interface"
#   }
# }

# resource "aws_security_group" "sg" {
#   tags = {
#     type = "terraform-test-security-group"
#   }
# }

  # security_groups = [aws.aws_security_group.allow_tls_ssh_http.id]  ##########################################
  # vpc_security_group_ids = "sg-023739ce9fca0b7b4"
  # vpc_security_group_ids = [aws.aws_security_group.allow_tls_ssh_http.id]

  # network_interface {
  #   network_interface_id = aws_network_interface.main_interface.id
  #   device_index         = 0
  # }

# resource "aws_key_pair" "my_key_for_all_AWS" {
#   key_name   = "my_key_for_all_AWS"
#   public_key = "-----BEGIN RSA PRIVATE KEY-----MIIEogIBAAKCAQEAvlhbxvXaFt9Xp/gIjD9BlTp9RIE6oRy/HAa5Hc2A7VXXxL6Dk3kvAdWivpYkvRWiG2ABvbejm/R3sUTfTt8iwIC2bbsIP8utuX3ydqZhCJJ9OQg0gHGdKR40txeHl3t6Z3ww/kwXnwBOd+gTfexA7f6LHNPO2pv/dO1R667QfiVC7q27w/8+Vst6PuZGa/6f1QLISzMF++HjH61xrrxeN12alFCxXy5FR8q7rqkTOCZODjB19HcFpWrR5mrRrosaQkvGubbnpkc04CcKV+3ELTb8FqZSTh1vba8NYlhx9h2dZEdZ9+vXXRA07D1HWYlSHhjV6yVLaC9OqpJKrQ9qFQIDAQABAoIBAAR8AG2HjUPMrzv90/W558mkPx9GDCOPkdEPN31EQi1VQGgaNO9cg4b/iX4D+4mY4ODUOjZGBUy/TbKXdMte5mqynZmoNmGKYuVj2jqBYPfau6iEUPhVtOYrGALYQxGGjzOw8VaMZGISl8araQombsEspgpf0xfDZRlUHgH3dGIEZDnlsaSUe4pJRIzeVAXDv8MO68d8XIUw2TreWEbq7s8ghJSLF216V/10as8GUbNb/UWGkGxQAdeDiubMfrHLvES+gdPAIkGd11EkpRqotxE5ozB25LvkTGw5v2ZsfzEsVW6BZsPzC0HdFXD2kExjwfkvEDqroIgW5WwB1gG6ZwECgYEA+3vLXTlJPGJXVkDWjg7GHXYem95hd3s5S3QN2GuSxEtij8SR7aLKzjE9xGHFhxG45qmlpQ3A1gpmo0Gbt6n3gw129reJeg2Jisq7L1KRG5bQDN6QZvcxmdN0oT+C1HEYe9PEXtJFW9y3ppYffB+onpJI9cOXdARR0FisR5mzLE0CgYEAwcN6UjocH1cja+2qw5+UcVMr/kOtFDbQpaUP0sCkAl4qLckq338UTK0IR6Q+81U8OLd4lg/Cbgbj8pEDP3DwwuYcrSWqcUkjpPJHAZpIeddHsdrj+st5ta5tjUSs5DTZlyVDw+BgUD33150UTLneUeXWRgByyC7nMOfoVLkYeOkCgYBr7V8DrTgvAA13aPArm0+PCUhtoGy3+FxIc5AVl2UvdSLhjH0MPVdIUn2tsEAzjXmLFLeQNGzT7zbJTbjkg79DsR2jGHWZugGTXRokXw0DiB/Vxha2+dOBruxY34boYXkee23FO/ykRf9TMQ5mGLgnBaTmRIDVO51ZCxU0zVPF6QKBgDhd3mK3RuETH1nRXODltnA1KtIf6+S6gX3+g5jis5OAwzJomBFGTah0mbkFnc552DgDn4+/6+bIGF3DM7er6k44VNVF5Mxp43WjiWZ89GKFbvTdYX7e3Hwuzu3OsaD9guMGUy1TQ5F0RXoy1unvFC6s9uWMUdfMVTMT87FZ2zWpAoGAIMdJNd3PZnxWaqXm/6W2ZwzG4HFIOzfhJ3Fe3oGZrdxwcYC+I17JCfz12PXXuZq9n26HpvY3JdVbkjDc1D5AffxPv+S1vD7SNrNk50IpFf20bMwfsxGwl0uF/bFMvD3sqyYPH9bCuzmqYz1EjJ1kQlnDnpRnbimXnoHvic8JIm8=-----END RSA PRIVATE KEY-----"
# }