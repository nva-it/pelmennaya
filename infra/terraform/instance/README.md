# Best guide terraform for Yandex Cloud Provider
- [Yandex Cloud Provider](https://terraform-eap.website.yandexcloud.net/docs/providers/yandex/index.html)

## Example Usage
```
// Configure the Yandex Cloud provider
provider "yandex" {
  token     = "auth_token_here"
  cloud_id  = "cloud_id_here"
  folder_id = "folder_id_here"
  zone      = "ru-central1-a"
}

// Create a new instance
resource "yandex_compute_instance" "default" {
  ...
}
```
# Don't forget to create your personal terraform.tfvars

## Example terraform.tfvars file
```
token     = "your OAUTH token"
cloud_id  = "your cloud id"
folder_id = "your folder id"
zone      = "VPC zone name"
```
