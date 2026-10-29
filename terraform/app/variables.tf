variable "aws_region" {
  type    = string
  default = "eu-west-3"
}

variable "project_name" {
  type    = string
  default = "paymybuddy-jenkins"
}

variable "instance_type" {
  type    = string
  default = "t3.small"
}

variable "key_name" {
  type    = string
  default = "jenkins-iac-key"
}

variable "root_volume_size" {
  type    = number
  default = 20
}

variable "ebs_size" {
  type    = number
  default = 10
}

variable "allowed_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}
