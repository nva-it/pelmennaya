terraform {
  required_providers {
    yandex = {
      source  = "terraform-registry.storage.yandexcloud.net/yandex-cloud/yandex"
      version = "0.72.0"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = var.yc_token #variable.tf
  cloud_id  = "мой cloud_id"
  folder_id = "мой folder_id"
  zone      = "ru-central1-b"
}


resource "yandex_vpc_network" "my-network" {
  name        = "my-network"
  description = "network for k8s"
  labels = {
    tf-label    = "tf-label-value"
    empty-label = ""
  }
}

resource "yandex_vpc_subnet" "my-subnet-network" {
  name           = "my-subnet-network"
  description    = "subnet for k8s"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.my-network.id
}

resource "yandex_iam_service_account" "cluster-account" {
  name        = "cluster-account"
  description = "k8s service account"
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {  
  folder_id = "мой folder_id"
  role      = "editor"
  members = [
    "serviceAccount:${yandex_iam_service_account.cluster-account.id}"
  ]
}


resource "yandex_resourcemanager_folder_iam_binding" "images-puller" {  
  folder_id = "мой folder_id"
  role      = "container-registry.images.puller"
  members = [
    "serviceAccount:${yandex_iam_service_account.cluster-account.id}"
  ]
}


resource "yandex_kubernetes_cluster" "my-kubernetes-cluster" {
  name       = "my-kubernetes-cluster"
  network_id = yandex_vpc_network.my-network.id
  master {
    zonal {
      zone      = yandex_vpc_subnet.my-subnet-network.zone
      subnet_id = yandex_vpc_subnet.my-subnet-network.id
    }
  }


  service_account_id      = yandex_iam_service_account.cluster-account.id
  node_service_account_id = yandex_iam_service_account.cluster-account.id
  depends_on = [
    yandex_resourcemanager_folder_iam_binding.editor,
    yandex_resourcemanager_folder_iam_binding.images-puller
  ]
}


resource "yandex_kubernetes_node_group" "my-cluster-nodes" {
  cluster_id = yandex_kubernetes_cluster.my-kubernetes-cluster.id
   
   instance_template {
   platform_id = "standard-v3"    
      
    network_interface {
      nat                = true
      subnet_ids         = ["${yandex_vpc_subnet.my-subnet-network.id}"]
    }

    resources {
      memory = 4
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }
   }

    scale_policy {
        auto_scale {
        min     = 1
        max     = 3
        initial = 2
        }
    }

    maintenance_policy {
    auto_upgrade = true
    auto_repair  = true
    }
}