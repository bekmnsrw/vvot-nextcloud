variable "cloud_id" {
    type        = string
    description = "Идентификатор облака в Yandex Cloud"
}

variable "folder_id" {
    type        = string
    description = "Идентификатор каталога в Yandex Cloud"
}

variable "yandex_zone" {
    type        = string
    description = "Зона доступности Yandex Cloud"
    default     = "ru-central1-a"
}

variable "sa_key_file_path" {
    type        = string
    description = "Путь к авторизованному ключу сервисного аккаунта"
    default     = "~/.yc-keys/key.json"
}

terraform {
    required_providers {
        yandex = {
            source = "yandex-cloud/yandex"
        }
    }
    required_version = ">= 0.13"
}

provider "yandex" {
    cloud_id                 = var.cloud_id
    folder_id                = var.folder_id
    zone                     = var.yandex_zone
    service_account_key_file = pathexpand(var.sa_key_file_path)
}