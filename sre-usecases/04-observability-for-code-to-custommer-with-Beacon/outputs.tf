# Network Information
output "vpc" {
  description = "AWS VPC ID for the created VPC"
  value       = module.vpc.vpc_id
}
# BIG-IQ Information
output "bigiq_mgmt_public_ips" {
  value = module.bigiq.mgmt_public_ips
}
output "bigiq_mgmt_port" {
  value = module.bigiq.bigiq_mgmt_port
}

output "bigiq_mgmt_public_dns" {
  value = module.bigiq.mgmt_public_dns
}

output "bigiq_private_addresses" {
  value = module.bigiq.private_addresses
}

output "bigiq_password" {
  description = "BIG-IQ management password"
  value       = module.bigiq.bigiq_password
}
# BIG-IP Information
output "public_nic_ids" {
  value = module.bigip.public_nic_ids
}

output "bigip_mgmt_public_ips" {
  value = module.bigip.mgmt_public_ips
}
output "bigip_mgmt_port" {
  value = module.bigip.bigip_mgmt_port
}

output "mgmt_public_dns" {
  value = module.bigip.mgmt_public_dns
}

output "private_addresses" {
  value = module.bigip.private_addresses
}

output "bigip_password" {
  description = "BIG-IP management password"
  value       = module.bigip.bigip_password
}
# Jumpbox information
output "jumphost_ip" {
  description = "ip address of jump host"
  value       = module.jumphost.jumphost_ip
}

output "juiceshop_ip" {
  value = module.jumphost.juiceshop_ips[*].public_ip
}

output "grafana_ip" {
  value = module.jumphost.grafana_ips[*].public_ip
}

# Instance Information
output "ec2_key_name" {
  description = "the key used to communication with ec2 instances"
  value       = var.ec2_key_name
}

