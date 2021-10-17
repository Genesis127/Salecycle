## Creating salecycle Servers for app subnet A
resource "aws_security_group" "sg_salecycle" {

  name   = "sg_salecycle"
  vpc_id = "${aws_vpc.salecycle_vpc.id}"
  tags = {
    Name        = "sg-salecycle"
    Environment = "${var.environment}"
  }

}

resource "aws_security_group_rule" "allow_all" {
  type              = "ingress"
  cidr_blocks       = ["10.1.0.0/24"]
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.sg_salecycle.id}"
}

resource "aws_security_group_rule" "outbound_allow_all" {
  type = "egress"

  cidr_blocks       = ["0.0.0.0/0"]
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.sg_salecycel.id}"
}



resource "aws_instance" "salecycle_a" {
  ami                    = "ami-0a887e401f7654935"
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.app_subnet_a.id}"
  vpc_security_group_ids = ["${aws_security_group.sg_salecycle.id}"]
  key_name               = "${aws_key_pair.myec2key.key_name}"

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo service httpd start
              sudo echo "<h1>hello world</h1>" > /tmp/techtask/www/index.html
             EOF

  tags = {
    Name        = "gen-salecycle-a"
    Environment = "${var.environment}"
  }

}

##  END Creating salecycle Servers for app subnet A


## Creating salecycle Servers for app subnet B

resource "aws_instance" "salecycle_b" {
  ami                    = "ami-0a887e401f7654935"
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.app_subnet_b.id}"
  vpc_security_group_ids = ["${aws_security_group.sg_salecycle.id}"]
  key_name               = "${aws_key_pair.myec2key.key_name}"

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo service httpd start
              sudo echo "<h1>hello world</h1>" > /tmp/techtask/www/index.html
             EOF

  tags = {
    Name        = "gen-salecycle-b"
    Environment = "${var.environment}"
  }

}
## END Creating salecycle Servers for app subnet B
