variable "availability_zone" { type = string }
variable "size" { type = number }
variable "name" { type = string }
variable "instance_id" { type = string }

resource "aws_ebs_volume" "this" {
  availability_zone = var.availability_zone
  size              = var.size
  type              = "gp3"
  tags = { Name = var.name }
}

resource "aws_volume_attachment" "this" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.this.id
  instance_id = var.instance_id
}

output "volume_id" { value = aws_ebs_volume.this.id }
