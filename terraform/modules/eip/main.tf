variable "instance_id" { type = string }
variable "name" { type = string }

resource "aws_eip" "this" {
  instance = var.instance_id
  domain   = "vpc"
  tags     = { Name = var.name }
}

output "public_ip" { value = aws_eip.this.public_ip }
output "allocation_id" { value = aws_eip.this.id }
