output "vpc_arn" {
  value = "Minha vpc arn: ${aws_vpc.vpc_network.arn}"
}
output "vpc_id" {
  value = "Minha vpc id: ${aws_vpc.vpc_network.id}"
}