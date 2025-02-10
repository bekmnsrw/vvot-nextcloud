variable "ansible_user" {
    type    = string
    default = "ubuntu"
}

variable "ansible_connection" {
    type    = string
    default = "ssh"
}

resource "null_resource" "add_to_known_hosts" {
    depends_on = [ 
        yandex_compute_instance.server,
    ]

    provisioner "local-exec" {
        command = "../terraform/add_known_host.sh ${yandex_compute_instance.server.network_interface[0].nat_ip_address}"
    }
}

resource "local_file" "ansible_inventory" {
    content = "server ansible_host=${yandex_compute_instance.server.network_interface[0].nat_ip_address} ansible_ssh_private_key_file=${var.ssh_private_key_path} ansible_user=${var.ansible_user} ansible_connection=${var.ansible_connection}"
    filename = "../ansible/inventory"
}

resource "null_resource" "ansible_provisioner" {
    depends_on = [ 
        yandex_compute_instance.server, 
        local_file.ansible_inventory,
        null_resource.add_to_known_hosts,
    ]

    provisioner "local-exec" {
        command = "ansible-playbook --become --become-user root --become-method sudo -i ../ansible/inventory ../ansible/nextcloud.yml"
    }
}