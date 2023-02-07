# variables.tf
# variable "access_key" {
#    default = "<PUT IN YOUR AWS ACCESS KEY>"
# }
# variable "secret_key" {
#    default = "<PUT IN YOUR AWS SECRET KEY>"
# }
variable "region" {
   default = "eu-central-1"
}
variable "availabilityZone" {
   default = "eu-central-1a"
}
variable "instanceType" {
   default = "t2.micro"
}
variable "keyName" {
   default = "my_key_for_all_AWS"
}
variable "keyPath" {
   default = "/home/ubuntu/My_website/my_key_for_all_AWS.pem"                   #"~/<PUT NAME AND PATH OF THE AWS PEM KEY>.pem"
}
# variable "subnet" {
#    default = "subnet-<PUT IN YOUR VPC SUBNET>"
# }
# variable "securityGroups" {
#    type = list
#    default = [ "sg-<PUT IN YOUR VPC SECURITY GROUP>" ]
# }
variable "instanceName" {
   default = "Django_WEB_Site"
}
# ami-0b898040803850657 is the free Amazon Linux 2 AMI
# for the us-east-1 region. Amazon Linux 2 
# is a downstream version of Red Hat Enterprise Linux / 
# Fedora / CentOS. It is analogous to RHEL 7.
variable "amis" {
   default = {
     "eu-central-1" = "ami-03e08697c325f02ab"
   }
}
# end of variables.tf