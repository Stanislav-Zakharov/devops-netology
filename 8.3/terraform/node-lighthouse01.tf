resource "yandex_compute_instance" "lighthouse01" {
  name                      = "lighthouse01"
  zone                      = "ru-central1-a"
  hostname                  = "lighthouse01.netology.yc"
  allow_stopping_for_update = true

  resources {
    cores  = "${var.instance_cpu}"
    memory = "${var.instance_ram}"
  }

  boot_disk {
    initialize_params {
      image_id    = "${var.centos-7-base}"
      name        = "root-lighthouse01"
      type        = "network-nvme"
      size        = "10"
    }
  }

  network_interface {
    subnet_id  = "${yandex_vpc_subnet.default.id}"
    nat        = true
    ip_address = "192.168.101.11"
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}
