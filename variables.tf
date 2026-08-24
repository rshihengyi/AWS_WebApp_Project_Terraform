variable "my_region" {
  description = "Region where the resource(s) will be managed"
  type        = string
  default     = null
}

variable "region_a" {
  type    = string
  default = null
}

variable "region_b" {
  type    = string
  default = null
}

variable "db_password" {
  type    = string
  default = null
}

variable "GITHUB_USERNAME" {
  type    = string
  default = null
}

variable "TF_REPO" {
  type    = string
  default = null
}

# locals {
#   private_subnet_a_id = [
#     aws_subnet.private_1a.id,
#     aws_subnet.private_2a.id
#   ]
# }

# locals {
#   private_subnet_b_id = [
#     aws_subnet.private_1b.id,
#     aws_subnet.private_2b.id
#   ]
# }