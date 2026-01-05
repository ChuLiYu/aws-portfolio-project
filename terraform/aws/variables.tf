variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "aws-portfolio"
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ssh_key_name" {
  description = "SSH key pair name for EC2 access (optional)"
  type        = string
  default     = ""
}

variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed to SSH (optional, leave empty to disable SSH)"
  type        = list(string)
  default     = []
}

variable "rate_limit_per_minute" {
  description = "Rate limit for API endpoints"
  type        = number
  default     = 100
}

variable "rate_limit_burst" {
  description = "Burst limit for rate limiting"
  type        = number
  default     = 200
}
