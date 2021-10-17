variable "cidr_vpc" {
  description = "CIDR for our VPC"
  default     = "10.1.0.0/16"

}

variable "environment" {
  description = "Environment of the resources"
  default     = "Dev"

}


variable "cidr_public_subnet_a" {
  description = "Subnet for the public subnet"
  default     = "10.1.0.0/24"

}

variable "cidr_public_subnet_b" {
  description = "Subnet for the public subnet"
  default     = "10.1.1.0/24"

}

variable "cidr_app_subnet_a" {
  description = "Subnet for the public subnet"
  default     = "10.1.2.0/24"

}

variable "cidr_app_subnet_b" {
  description = "Subnet for the public subnet"
  default     = "10.1.3.0/24"

}



variable "az_a" {
  description = "Availablilty zone for the subnet"
  default     = "eu-west-1a"
}


variable "az_b" {
  description = "Availablilty zone for the subnet"
  default     = "eu-west-1b"

}
