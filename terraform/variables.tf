variable "aws_region" {
  description = "The AWS region to deploy to"
  default     = "us-east-1"
}

variable "ami_id" {
  description = "The AMI ID for the instance"
  default     = "ami-04b70fa74e45c3917" # Update to a valid AMI ID for your region
}

variable "instance_type" {
  description = "The instance type to use"
  default     = "t2.medium"
}

variable "key_name" {
  description = "The name of the SSH key pair"
}
