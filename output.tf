# output.tf
output "public_ip" {
    value = aws_radar_instance.radar.ipv4_address
}

output "private_ip" {
    value = aws_radar_instance.ipv4_address_private
}

output "hostname" {
    value = aws_radar_instance.radar.hostname
}