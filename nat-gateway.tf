## Create a nat gateway for public a subnet
resource "aws_eip" "eip_public_a" {
  vpc = true
}
resource "aws_nat_gateway" "gw_public_a" {
  allocation_id = "${aws_eip.eip_public_a.id}"
  subnet_id     = "${aws_subnet.public_subnet_a.id}"

  tags = {
    Name = "salecycle-nat-public-a"
  }
}
## End creating nat gateway in public A subnet


## Create Routing Table for app A subnet
resource "aws_route_table" "rtb_appa" {

  vpc_id = "${aws_vpc.salecycle_vpc.id}"
  tags = {
    Name        = "salecycle-appa-routetable"
    Environment = "${var.environment}"
  }

}

#Create a route to nat gateway 
resource "aws_route" "route_appa_nat" {
  route_table_id         = "${aws_route_table.rtb_appa.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.gw_public_a.id}"
}


resource "aws_route_table_association" "rta_subnet_association_appa" {
  subnet_id      = "${aws_subnet.app_subnet_a.id}"
  route_table_id = "${aws_route_table.rtb_appa.id}"
}

##  End creating routing table for app A subnet


## Create Nat gatway and routes for app subnet B 
resource "aws_eip" "eip_public_b" {
  vpc = true
}
resource "aws_nat_gateway" "gw_public_b" {
  allocation_id = "${aws_eip.eip_public_b.id}"
  subnet_id     = "${aws_subnet.public_subnet_b.id}"

  tags = {
    Name = "salecycle-nat-public-b"
  }
}

resource "aws_route_table" "rtb_appb" {

  vpc_id = "${aws_vpc.salecycle_vpc.id}"
  tags = {
    Name        = "salecycle-appb-routetable"
    Environment = "${var.environment}"
  }

}

resource "aws_route" "route_appb_nat" {
  route_table_id         = "${aws_route_table.rtb_appb.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.gw_public_b.id}"
}


resource "aws_route_table_association" "rta_subnet_association_appb" {
  subnet_id      = "${aws_subnet.app_subnet_b.id}"
  route_table_id = "${aws_route_table.rtb_appb.id}"
}
## END Create Nat gatway and routes for app subnet B 
