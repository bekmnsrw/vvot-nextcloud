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

variable "ssh_key_path" {
    type        = string
    description = "Путь к SSH-ключу для сервера"
    default     = "~/.ssh/id_ed25519.pub"
}

variable "image_family_id" {
    type        = string
    default     = "ubuntu-2404-lts-oslogin"
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
    hostname    = "ubuntu"

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
        ssh-keys = "ubuntu:${file(var.ssh_key_path)}"
    }
}
