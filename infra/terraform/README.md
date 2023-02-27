Развертываение инфраструктуры с помощью Terraform в Yandex Cloud:

```
export YC_TOKEN=`yc iam create-token`
terraform init
terraform plan -var "yc_token=${YC_TOKEN}"
terraform apply  -var "yc_token=${YC_TOKEN}"

```
Так же можно создать свой terraform.tfvars :
```
token     = "your OAUTH token"
cloud_id  = "your cloud id"
folder_id = "your folder id"
zone      = "VPC zone name"
```


Полная инструкция по всей инфраструктуре [Yandex Cloud Provider](https://terraform-eap.website.yandexcloud.net/docs/providers/yandex/index.html)
