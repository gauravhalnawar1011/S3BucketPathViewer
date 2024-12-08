output "instance_id" {
  description = "List of IDs of instances"
  value       = aws_instance.flaskserver.id
}
