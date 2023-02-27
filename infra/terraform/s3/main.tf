terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = ">= 0.81.0"
    }
  }
}


provider "yandex" {
  token     = var.yc_token  #variable.tf
  cloud_id  = "мой cloud_id  "
  folder_id = " мой folder_id "
  zone      = "ru-central1-b"
}
 
// create service account
resource "yandex_iam_service_account" "bucket-user" {
  name      = "bucket-user"
}

// set role to service account
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.bucket-user.id}"
  folder_id = " мой folder_id "
}

// create static key
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.bucket-user.id
  description        = "static access key for object storage"
}

// create bucket
resource "yandex_storage_bucket" "xray-terrafomr" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = "xray-terrafomr"
 
  lifecycle_rule {
      id      = "log"
      enabled = true
      prefix = "log/"
    
      transition  {
      days    = 30
      storage_class = "COLD"
      }

      expiration {
      days = 90
      }
  }

  lifecycle_rule {
    id  = "tmp"
    prefix = "tmp/"
    enabled =  true

    expiration {
      date = "2023-12-31"
    }
  }

}  
