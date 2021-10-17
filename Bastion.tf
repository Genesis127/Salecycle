## Create Bastion Server

resource "aws_key_pair" "myec2key" {
  key_name   = "genPublicKey"
  public_key = "${file("/home/gen/.ssh/id_rsa.pub")}"
}

resource "aws_security_group" "sg_22" {

  name   = "sg_22"
  vpc_id = "${aws_vpc.salecycle_vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "sg-22"
    Environment = "${var.environment}"
  }

}


# Create NACL for access bastion host via port 22
resource "aws_network_acl" "salecycle_public_a" {
  vpc_id = "${aws_vpc.salecycle_vpc.id}"

  subnet_ids = ["${aws_subnet.public_subnet_a.id}"]

  tags = {
    Name        = "acl-salecycle-public-a"
    Environment = "${var.environment}"
  }
}

resource "aws_network_acl_rule" "inbound_rule_22" {
  network_acl_id = "${aws_network_acl.salecycle_public_a.id}"
  rule_number    = 200
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  # Of course in a real time environment we will not open to 0.0.0.0/0. Same for outbound rules.
  cidr_block = "0.0.0.0/0"
  from_port  = 0
  to_port    = 0
}

resource "aws_network_acl_rule" "outbound_rule_22" {
  network_acl_id = "${aws_network_acl.salecycle_public_a.id}"
  rule_number    = 200
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block = "0.0.0.0/0"
  from_port  = 0
  to_port    = 0
}
# Create NACL for access bastion host via port 22

resource "aws_instance" "salecycle_bastion" {
  ami                    = "ami-0a887e401f7654935"
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.public_subnet_a.id}"
  vpc_security_group_ids = ["${aws_security_group.sg_22.id}"]
  key_name               = "${aws_key_pair.myec2key.key_name}"

  tags = {
    Name        = "salecycle-bastion"
    Environment = "${var.environment}"
  }

}
