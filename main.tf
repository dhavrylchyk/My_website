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
  region = "eu-central-1"
}

# resource "aws_vpc" "main" {
#   cidr_block       = "10.0.0.0/16"
#   instance_tenancy = "default"

#   tags = {
#     Name = "main"
#   }
# }


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


resource "aws_instance" "app_server" {
  ami           = "ami-03e08697c325f02ab"
  instance_type = "t2.micro"
  key_name = "my_key_for_all_AWS"
  private_ip = "10.0.0.12"
  subnet_id     = aws_subnet.main_subnet.id



  # security_groups = [aws.aws_security_group.allow_tls_ssh_http.id]  ##########################################
  # vpc_security_group_ids = "sg-023739ce9fca0b7b4"
  # vpc_security_group_ids = [aws.aws_security_group.allow_tls_ssh_http.id]

  # network_interface {
  #   network_interface_id = aws_network_interface.main_interface.id
  #   device_index         = 0
  # }

  credit_specification {
    cpu_credits = "unlimited"
  }

  tags = {
    Name = "Django_WEB_Site"
  }
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.allow_tls_ssh_http.id
  network_interface_id = aws_instance.app_server.primary_network_interface_id
}

# resource "aws_key_pair" "my_key_for_all_AWS" {
#   key_name   = "my_key_for_all_AWS"
#   public_key = "-----BEGIN RSA PRIVATE KEY-----MIIEogIBAAKCAQEAvlhbxvXaFt9Xp/gIjD9BlTp9RIE6oRy/HAa5Hc2A7VXXxL6Dk3kvAdWivpYkvRWiG2ABvbejm/R3sUTfTt8iwIC2bbsIP8utuX3ydqZhCJJ9OQg0gHGdKR40txeHl3t6Z3ww/kwXnwBOd+gTfexA7f6LHNPO2pv/dO1R667QfiVC7q27w/8+Vst6PuZGa/6f1QLISzMF++HjH61xrrxeN12alFCxXy5FR8q7rqkTOCZODjB19HcFpWrR5mrRrosaQkvGubbnpkc04CcKV+3ELTb8FqZSTh1vba8NYlhx9h2dZEdZ9+vXXRA07D1HWYlSHhjV6yVLaC9OqpJKrQ9qFQIDAQABAoIBAAR8AG2HjUPMrzv90/W558mkPx9GDCOPkdEPN31EQi1VQGgaNO9cg4b/iX4D+4mY4ODUOjZGBUy/TbKXdMte5mqynZmoNmGKYuVj2jqBYPfau6iEUPhVtOYrGALYQxGGjzOw8VaMZGISl8araQombsEspgpf0xfDZRlUHgH3dGIEZDnlsaSUe4pJRIzeVAXDv8MO68d8XIUw2TreWEbq7s8ghJSLF216V/10as8GUbNb/UWGkGxQAdeDiubMfrHLvES+gdPAIkGd11EkpRqotxE5ozB25LvkTGw5v2ZsfzEsVW6BZsPzC0HdFXD2kExjwfkvEDqroIgW5WwB1gG6ZwECgYEA+3vLXTlJPGJXVkDWjg7GHXYem95hd3s5S3QN2GuSxEtij8SR7aLKzjE9xGHFhxG45qmlpQ3A1gpmo0Gbt6n3gw129reJeg2Jisq7L1KRG5bQDN6QZvcxmdN0oT+C1HEYe9PEXtJFW9y3ppYffB+onpJI9cOXdARR0FisR5mzLE0CgYEAwcN6UjocH1cja+2qw5+UcVMr/kOtFDbQpaUP0sCkAl4qLckq338UTK0IR6Q+81U8OLd4lg/Cbgbj8pEDP3DwwuYcrSWqcUkjpPJHAZpIeddHsdrj+st5ta5tjUSs5DTZlyVDw+BgUD33150UTLneUeXWRgByyC7nMOfoVLkYeOkCgYBr7V8DrTgvAA13aPArm0+PCUhtoGy3+FxIc5AVl2UvdSLhjH0MPVdIUn2tsEAzjXmLFLeQNGzT7zbJTbjkg79DsR2jGHWZugGTXRokXw0DiB/Vxha2+dOBruxY34boYXkee23FO/ykRf9TMQ5mGLgnBaTmRIDVO51ZCxU0zVPF6QKBgDhd3mK3RuETH1nRXODltnA1KtIf6+S6gX3+g5jis5OAwzJomBFGTah0mbkFnc552DgDn4+/6+bIGF3DM7er6k44VNVF5Mxp43WjiWZ89GKFbvTdYX7e3Hwuzu3OsaD9guMGUy1TQ5F0RXoy1unvFC6s9uWMUdfMVTMT87FZ2zWpAoGAIMdJNd3PZnxWaqXm/6W2ZwzG4HFIOzfhJ3Fe3oGZrdxwcYC+I17JCfz12PXXuZq9n26HpvY3JdVbkjDc1D5AffxPv+S1vD7SNrNk50IpFf20bMwfsxGwl0uF/bFMvD3sqyYPH9bCuzmqYz1EjJ1kQlnDnpRnbimXnoHvic8JIm8=-----END RSA PRIVATE KEY-----"
# }