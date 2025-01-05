variable "ubuntu_22_img_url" {
  description = "ubuntu 22.04 image"
  default     = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
}

variable "img_path" {
  description = "ubuntu 22.04 image local path"
  default     = "default"
}

variable "interface" {
  type    = string
  default = "ens3"
}

#load balancer
variable "master_ips" {
  type    = list(any)
  default = ["192.168.122.10"]
}

variable "master_memory" {
  type    = string
  default = "3072"
}

variable "master_vcpu" {
  type    = number
  default = 2
}

variable "master_disk" {
  type    = number
  default = "10737418240"
}

variable "master_hostname" {
  type    = list(string)
  default = ["k3s-master"]
}

#application server
variable "app_ips" {
  type    = list(any)
  default = ["192.168.122.11", "192.168.122.12"]
}

variable "app_memory" {
  type    = string
  default = "2048"
}

variable "app_vcpu" {
  type    = number
  default = 1
}

variable "app_disk" {
  type    = number
  default = "10737418240"
}

variable "app_hostname" {
  type    = list(string)
  default = ["k3s-worker1", "k3s-worker2"]
}
