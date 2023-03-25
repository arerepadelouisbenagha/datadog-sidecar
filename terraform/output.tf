output "reactapp-ip" {
  value = [aws_instance.reactapp-instance.public_ip]
}

output "website_url" {
  value = "http://${aws_instance.reactapp-instance.public_ip}:80/"
}