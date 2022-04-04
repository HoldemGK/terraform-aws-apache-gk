variable "instance_type" {
  type        = string
  description = "The size of image"
  default     = "t2.micro"
}

variable "vpc_id" {
  type        = string
  default     = "vpc-7130d30c"
}

variable "allow_ip" {
  type        = string
  description = "Provide your IP"
}

variable "public_key" {
  type        = string
  description = "Provide your public_key"
}

variable "server_name" {
  type        = string
  default     = "AppServer"
}