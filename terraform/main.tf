variable "cloud_id" {
  description = "ID облака"
}

variable "folder_id" {
  description = "ID каталога"
}

variable "zone" {
  description = "Зона облака"
}

variable "subnet_id" {
  description = "ID подсети для создания ресурсов"
}

terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.80"
    }
  }
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone

  service_account_key_file = file("authorized_key.json")
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_disk" "testvm" {
  name     = "test-vm-disk"
  type     = "network-ssd"
  zone     = var.zone
  image_id = data.yandex_compute_image.ubuntu.image_id
  size     = 15
}

resource "yandex_compute_instance" "testvm" {
  name = "test-vm"
  zone = var.zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.testvm.id
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
