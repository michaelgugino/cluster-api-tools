variable "key_name" {
  description = "Desired name of AWS key pair"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

# CentOS 7
variable "aws_amis" {
  default = {
    us-east-1 = "ami-02eac2c0129f6376b"
  }
}

variable "fedora_ami" {
  default = {
    us-east-1 = "ami-0d15d66ed1fb94f17"
  }
}
