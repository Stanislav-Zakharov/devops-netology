## Домашнее задание к занятию "7.2. Облачные провайдеры и синтаксис Terraform."
1. Задача 1 (Вариант с Yandex.Cloud). Регистрация в ЯО и знакомство с основами (необязательно, но крайне желательно).
    > Для того чтобы не указывать авторизационный токен в коде, а терраформ провайдер брал его из переменных окружений, необходимо экспортировать данные для авторизации в соответствующие переменные окружения
    ```bash
    export YC_TOKEN=$(yc iam create-token)
    export YC_CLOUD_ID=$(yc config get cloud-id)
    export YC_FOLDER_ID=$(yc config get folder-id)
    ```
2. Задача 2. Создание yandex_compute_instance через терраформ.
    > * Для создания собственных базовых образов необходимо использовать [Packer](https://www.packer.io/)
    > * [terraform configuration link](../terraform)  
    ```bash
    $ terraform validate
    Success! The configuration is valid.

    terraform plan 
    data.yandex_compute_image.ubuntu_base_image: Reading...
    data.yandex_compute_image.ubuntu_base_image: Read complete after 1s [id=fd8k5kam36qhmnojj8je]

    Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
    + create

    Terraform will perform the following actions:

    # yandex_compute_instance.vm-1 will be created
    + resource "yandex_compute_instance" "vm-1" {
        + created_at                = (known after apply)
        + folder_id                 = (known after apply)
        + fqdn                      = (known after apply)
        + hostname                  = (known after apply)
        + id                        = (known after apply)
        + metadata                  = {
            + "user-data" = <<-EOT
                    users:
                    - name: zaharov
                        groups: sudo
                        shell: /bin/bash
                        sudo: ['ALL=(ALL) NOPASSWD:ALL']
                        ssh_authorized_keys:
                        - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCp1R2pf305TwZ2APQ+uZ4NwBNJDvLYgUL/yam6IaqWSZlgZzBPjH/G2/J0pWOxDb9j3eN5bobIfj5PSk4cZX73Y/qXlO6LgcJ/eWL4Ksy4hFSUyrCnNCEu9SkNI3WM9g8CJFZyUNPTjZOjob7IhHaQAXH45/OaY32FUuGGSAreh+F1fMwzgYWzHMuZd13Lo5uOfcjPNSWxTkr/hziqnKClpHg5U7QQ1ikQAlPoXm3p1AdlOUrrNdtGu3XJfCK7TsFLNfHLREaxD5GEagZDMY4SYle0SRvXayYJWq/L+ktrEBoPCJ6KLh3E2godOa79a40Ym8xIPYDvosHabmhBwm/EAIBeMk7mcnLcRKRPq7tECZTehS+M+l+y55m7C6Sg50BY0tzXvIrlyJvuvvKVnrgY/VQQsuPcInHfA2oVDYqnrFB/5Bu+P/dirnf7V3lpvzU/XZ1JcB1Tds+awYLQlzbZ8Qdx7h5bSDy0QfDOCtJGgGvMVnq8VvhF3mAKrh9kIH8= stanislav@TM1707
                EOT
            }
        + name                      = "vm1"
        + network_acceleration_type = "standard"
        + platform_id               = "standard-v1"
        + service_account_id        = (known after apply)
        + status                    = (known after apply)
        + zone                      = (known after apply)

        + boot_disk {
            + auto_delete = true
            + device_name = (known after apply)
            + disk_id     = (known after apply)
            + mode        = (known after apply)

            + initialize_params {
                + block_size  = (known after apply)
                + description = (known after apply)
                + image_id    = "fd8k5kam36qhmnojj8je"
                + name        = (known after apply)
                + size        = (known after apply)
                + snapshot_id = (known after apply)
                + type        = "network-hdd"
                }
            }

        + network_interface {
            + index              = (known after apply)
            + ip_address         = (known after apply)
            + ipv4               = true
            + ipv6               = (known after apply)
            + ipv6_address       = (known after apply)
            + mac_address        = (known after apply)
            + nat                = true
            + nat_ip_address     = (known after apply)
            + nat_ip_version     = (known after apply)
            + security_group_ids = (known after apply)
            + subnet_id          = (known after apply)
            }

        + placement_policy {
            + host_affinity_rules = (known after apply)
            + placement_group_id  = (known after apply)
            }

        + resources {
            + core_fraction = 100
            + cores         = 1
            + memory        = 1
            }

        + scheduling_policy {
            + preemptible = (known after apply)
            }
        }

    # yandex_vpc_network.network_test_01 will be created
    + resource "yandex_vpc_network" "network_test_01" {
        + created_at                = (known after apply)
        + default_security_group_id = (known after apply)
        + folder_id                 = (known after apply)
        + id                        = (known after apply)
        + labels                    = (known after apply)
        + name                      = "net_terraform"
        + subnet_ids                = (known after apply)
        }

    # yandex_vpc_subnet.subnet_test_01 will be created
    + resource "yandex_vpc_subnet" "subnet_test_01" {
        + created_at     = (known after apply)
        + folder_id      = (known after apply)
        + id             = (known after apply)
        + labels         = (known after apply)
        + name           = "sub_terraform"
        + network_id     = (known after apply)
        + v4_cidr_blocks = [
            + "192.168.0.0/24",
            ]
        + v6_cidr_blocks = (known after apply)
        + zone           = "ru-central1-a"
        }

    Plan: 3 to add, 0 to change, 0 to destroy.

    ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ```