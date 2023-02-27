#----------Datasource for VPC network and subnet

data "yandex_vpc_network" "default" {
  name = "default"
}

data "yandex_vpc_subnet" "default" {
  name = "${data.yandex_vpc_network.default.name}-${var.network_zone}"
}