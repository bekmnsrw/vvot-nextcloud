variable "network_name" {
    type    = string
    default = "vvot09-server-network"
}

variable "subnet_name" {
    type    = string
    default = "vvot09-server-subnet"
}

variable "boot_disk_name" {
    type    = string
    default = "vvot09-server-boot-disk"
}

variable "server_name" {
    type    = string
    default = "vvot09-server"
}

variable "ssh_public_key_path" {
    type        = string
    description = "Путь к публичному SSH-ключу для сервера"
    default     = "~/.ssh/id_ed25519.pub"
}

variable "ssh_private_key_path" {
    type        = string
    description = "Путь к приватному SSH-ключу для сервера"
    default     = "~/.ssh/id_ed25519"
}

variable "image_family_id" {
    type        = string
    default     = "ubuntu-2404-lts-oslogin"
}

variable "dns_zone" {
    type    = string
    default = "vvot09.itiscl.ru."
}

variable "dns_recordset_name" {
    type    = string
    default = "nextcloud_recordset"
}

variable "dns_zone_name" {
    type    = string
    default = "ru-itiscl-vvot09"
}

variable "dns_name" {
    type    = string
    default = "project"
}

resource "yandex_vpc_network" "network" {
    name = var.network_name
}

resource "yandex_vpc_subnet" "subnet" {
    name           = var.subnet_name
    zone           = var.yandex_zone
    v4_cidr_blocks = ["192.168.10.0/24"]
    network_id     = yandex_vpc_network.network.id
}

data "yandex_compute_image" "ubuntu_image" {
    family = var.image_family_id
}

resource "yandex_compute_disk" "boot_disk" {
    name     = var.boot_disk_name
    type     = "network-ssd"
    image_id = data.yandex_compute_image.ubuntu_image.id
    size     = 10
}

resource "yandex_compute_instance" "server" {
    name        = var.server_name
    platform_id = "standard-v3"
    hostname    = "server"

    resources {
        core_fraction = 20
        cores         = 2
        memory        = 1
    }

    boot_disk {
        disk_id = yandex_compute_disk.boot_disk.id
    }

    network_interface {
        subnet_id = yandex_vpc_subnet.subnet.id
        nat = true
    }

    metadata = {
        ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
    }
}

resource "yandex_dns_zone" "zone" {
    zone   = var.dns_zone
    name   = var.dns_zone_name     
    public = true            
}

resource "yandex_dns_recordset" "recordset" {
    zone_id = yandex_dns_zone.zone.id 
    name    = var.dns_name                     
    type    = "A"
    ttl     = 300
    data    = [yandex_compute_instance.server.network_interface[0].nat_ip_address]
}
