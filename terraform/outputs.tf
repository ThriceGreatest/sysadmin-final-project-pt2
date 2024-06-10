output "instance_ip" {
  description = "The public IP address of the Minecraft server"
  value       = aws_instance.minecraft.public_ip
}
