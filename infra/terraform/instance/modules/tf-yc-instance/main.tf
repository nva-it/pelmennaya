resource "yandex_compute_instance" "vm-1" {
  name = var.name
  platform_id = var.platform_id
  zone = var.zone

  resources {
    cores  = var.cores
    memory = var.memory
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size = var.size
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = var.nat
  }

  scheduling_policy {
    preemptible = true
  }

  metadata = {
    user-data = "${file("~/.ssh/meta.txt")}"
  }

}
