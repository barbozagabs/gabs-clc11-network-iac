variable "vpc_name" {
  type        = string
  default     = "vpc_iac_clc11"
  description = "Nome da VPC criada via IAC"
}

variable "vpc_range" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_privada_1a_range" {
  type    = string
  default = "10.0.10.0/24"
}

variable "subnet_publica_1a_range" {
  type    = string
  default = "10.0.20.0/24"
}

variable "subnet_privada_1c_range" {
  type    = string
  default = "10.0.100.0/24"
}

variable "subnet_publica_1c_range" {
  type    = string
  default = "10.0.200.0/24"
}

variable "availability_zone_1a" {
  type    = string
  default = "us-east-1a"
}

variable "availability_zone_1c" {
  type    = string
  default = "us-east-1c"
}

variable "internet_gatewy" {
  type    = string
  default = "igw_vpc_iac_clc11"
}