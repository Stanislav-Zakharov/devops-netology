# Заменить на ID своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_cloud_id" {
  default = "b1gqkf5n3n0nagsj3qhd"
}

# Заменить на Folder своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_folder_id" {
  default = "b1gp988j05jspq8qe96m"
}

# Заменить на ID своего образа
# ID можно узнать с помощью команды yc compute image list
variable "centos-7-base" {
  default = "fd8jvcoeij6u9se84dt5"
}

variable "instance_cpu" {
  default = 2
}

variable "instance_ram" {
  default = 2
}
