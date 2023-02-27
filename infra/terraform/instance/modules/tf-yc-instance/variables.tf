#-------------Instance-------------
variable "name" {
  description = "Enter YC instance name"
  type        = string
  default     = "chapter5-lesson2-std-009-013"
}

variable "platform_id" {
  description = "Enter YC platform id for instance "
  type        = string
  default     = "standard-v1"
}

variable "zone" {
  description = "Enter YC VPC subnet name for deploy instance"
  type        = string
  default     = "ru-central1-a"
}

variable "cores" {
  description = "Enter CPU cores for the instance"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Enter Memory size in GB"
  type        = number
  default     = 4
}

variable "image_id" {
  description = "Enter a disk image id for boot disk"
  type        = string
  default     = "fd80qm01ah03dkqb14lc"
}

variable "size" {
  description = "Enter  Size of the disk in GB"
  type        = number
  default     = 30
}

variable "subnet_id" {
  description = "ID of the subnet to attach this interface to"
  type        = string
  default     = "e9bg8cjovk4tpbk8h6m7"
}

variable "nat" {
  description = "Provide a public address, for instance, to access the internet over NAT"
  type        = bool
  default     = true
}

variable "preemptible" {
  description = "Specifies if the instance is preemptible"
  type        = bool
  default     = true
}
#-------------End Instance-------------