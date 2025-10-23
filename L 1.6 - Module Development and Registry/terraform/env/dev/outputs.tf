output "peer_1_id" {
  value = aws_vpc_peering_connection.peer_1.id
}

output "peer_3_request_id" {
  value = aws_vpc_peering_connection.peer_3_request.id
}

output "vpc_1a_id" {
  value = module.vpc_1a.vpc_id
}

output "vpc_1b_id" {
  value = module.vpc_1b.vpc_id
}

output "vpc_3a_self_id" {
  value = module.vpc_3a_self.vpc_id
}
