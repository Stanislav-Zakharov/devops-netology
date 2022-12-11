provider "yandex" {
  zone = "ru-cental1-a"
}

data "yandex_compute_image" "ubuntu_base_image" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "vm-1" {
  name = "vm1"

  resources {
    cores  = 1
    memory = 1
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_base_image.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_test_01.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
  }

}

resource "yandex_vpc_network" "network_test_01" {
  name = "net_terraform"
}

resource "yandex_vpc_subnet" "subnet_test_01" {
  name           = "sub_terraform"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network_test_01.id
  v4_cidr_blocks = ["192.168.0.0/24"]
}
