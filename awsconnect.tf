provider "aws"{
region = "us-east-1"
profile = "Terraform_Aws"
}
resource "aws_instance" "Sample_demo" {
ami = "ami-020cba7c55df1f615"
instance_type = "t2.micro"
tags = {
Name = "EC2_Security_Groups"
}
}
#use the default VPC
data "aws_vpc" "default" {
default = true
}
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port         = 443
    to_port           = 443
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    ipv6_cidr_blocks  = ["::/0"]
  }

  egress {
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
    ipv6_cidr_blocks  = ["::/0"]
  }

  tags = {
    Name = "EC2_Security_Groups"
  }
}
# Ingress Rule for IPv4 - HTTPS traffic within the VPC
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
security_group_id = aws_security_group.allow_tls.id
#If public HTTPS access is required then
cidr_ipv4 = "0.0.0.0/0"
from_port = 443
to_port = 443
ip_protocol = "tcp"
}
# Ingress Rule for IPv6 - HTTPS traffic within the VPC
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
security_group_id = aws_security_group.allow_tls.id
cidr_ipv6 = "::/0"
from_port = 443
ip_protocol = "tcp"
to_port = 443
}
# Egress Rule - Allow all outbound IPv4 traffic
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
security_group_id = aws_security_group.allow_tls.id
cidr_ipv4 = "0.0.0.0/0"
ip_protocol = "-1" # semantically equivalent to all ports
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
security_group_id = aws_security_group.allow_tls.id
cidr_ipv6 = "::/0"
ip_protocol = "-1" # semantically equivalent to all ports
}
