## Create the internet gateway
resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Env     = "${var.environment}"
    Name    = "${var.environment}-igw"
  }
}

# Create the EIP for the NAT Gateways
resource "aws_eip" "nat_ips" {
  count  = "${length(var.availability_zones)}"
  vpc    = true
}

# Associate the EIP's to the gateway instances
resource "aws_nat_gateway" "nat_gws" {
  depends_on    = ["aws_internet_gateway.main"]

  count         = "${length(var.availability_zones)}"
  allocation_id = "${element(aws_eip.nat_ips.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.nat_subnets.*.id, count.index)}"
}
