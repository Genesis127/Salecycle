## Creating a application load balancer to access the app
resource "aws_security_group" "sg_application_lb" {

  name   = "sg_application_lb"
  vpc_id = "${aws_vpc.salecycle_vpc.id}"

  ingress {
    # TLS 
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
  }


  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = "${var.environment}"
  }

}


resource "aws_lb" "lb_salecycle" {
  name               = "salecycle-elb"
  internal           = false
  load_balancer_type = "application"
  subnets            = ["${aws_subnet.public_subnet_a.id}", "${aws_subnet.public_subnet_b.id}"]
  security_groups    = ["${aws_security_group.sg_application_lb.id}"]

  enable_deletion_protection = false



  tags = {
    Environment = "${var.environment}"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = "${aws_lb.lb_salecycle.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.salecycle_vms.arn}"
  }
}


resource "aws_lb_target_group" "salecycle_vms" {
  name     = "tf-salecycle-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.salecycle_vpc.id}"
}

resource "aws_lb_target_group_attachment" "salecycle_tg_attachment" {
  target_group_arn = "${aws_lb_target_group.salecycle_vms.arn}"
  target_id        = "${aws_instance.salecycle_a.id}"
  port             = 80
}


## Attach salecycle B to target group
resource "aws_lb_target_group_attachment" "salecycleb_tg_attachment" {
  target_group_arn = "${aws_lb_target_group.sale_vms.arn}"
  target_id        = "${aws_instance.salecycle_b.id}"
  port             = 80
}
