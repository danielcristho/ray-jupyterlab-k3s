resource "null_resource" "cache_image" {
  provisioner "local-exec" {
    command = "wget -O /tmp/ubuntu-22.04.qcow2 ${var.ubuntu_22_img_url}"
  }
}

resource "libvirt_volume" "base" {
  name       = "base.qcow2"
  source     = "/tmp/ubuntu-22.04.qcow2"
  pool       = "default"
  format     = "qcow2"
  depends_on = [null_resource.cache_image]
}

resource "libvirt_cloudinit_disk" "master_commoninit" {
  count = length(var.master_hostname)
  name  = "${var.master_hostname[count.index]}-commoninit.iso"
  user_data = templatefile("${path.module}/config/cloud_init.yml", {
    hostname = var.master_hostname[count.index]
  })
  network_config = templatefile("${path.module}/config/network_config.yml", {
    interface = var.interface
    ip_addr   = var.master_ips[count.index]
  })
}

resource "libvirt_volume" "master_ubuntu2204-qcow2" {
  count          = length(var.master_hostname)
  name           = "ubuntu2204-${var.master_hostname[count.index]}.qcow2"
  base_volume_id = libvirt_volume.base.id
  pool           = "default"
  size           = var.master_disk
}

resource "libvirt_domain" "master" {
  count  = length(var.master_hostname)
  name   = var.master_hostname[count.index]
  memory = var.master_memory
  vcpu   = var.master_vcpu

  network_interface {
    network_name = "default"
    addresses    = [var.master_ips[count.index]]
  }

  disk {
    volume_id = element(libvirt_volume.master_ubuntu2204-qcow2.*.id, count.index)
  }

  cloudinit = libvirt_cloudinit_disk.master_commoninit[count.index].id

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

resource "libvirt_cloudinit_disk" "app_commoninit" {
  count = length(var.app_hostname)
  name  = "${var.app_hostname[count.index]}-commoninit.iso"
  user_data = templatefile("${path.module}/config/cloud_init.yml", {
    hostname = var.app_hostname[count.index]
  })
  network_config = templatefile("${path.module}/config/network_config.yml", {
    interface = var.interface
    ip_addr   = var.app_ips[count.index]
  })
}

resource "libvirt_volume" "app_ubuntu2204-qcow2" {
  count          = length(var.app_hostname)
  name           = "ubuntu2204-${var.app_hostname[count.index]}.qcow2"
  base_volume_id = libvirt_volume.base.id
  pool           = "default"
  size           = var.app_disk
}

resource "libvirt_domain" "application_server" {
  count  = length(var.app_hostname)
  name   = var.app_hostname[count.index]
  memory = var.app_memory
  vcpu   = var.app_vcpu

  network_interface {
    network_name = "default"
    addresses    = [var.app_ips[count.index]]
  }

  disk {
    volume_id = element(libvirt_volume.app_ubuntu2204-qcow2.*.id, count.index)
  }

  cloudinit = libvirt_cloudinit_disk.app_commoninit[count.index].id

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}