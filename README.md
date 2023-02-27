Сайт магазина: https://momo.vnaz.site (сайт не доступен, как и все другие ниже сервисы по причине остановки кубера)

# Momo Store aka Пельменная №2

<img width="900" alt="image" src="https://user-images.githubusercontent.com/9394918/167876466-2c530828-d658-4efe-9064-825626cc6db5.png">

## Сборка module-pipline в GitLab

##### backend
<img width="900" alt="image" src="https://storage.yandexcloud.net/xray/momo-store/momo-b.jpg">

##### frontend
<img width="900" alt="image" src="https://storage.yandexcloud.net/xray/momo-store/momo-f.jpg">

##### helm
<img width="900" alt="image" src="https://storage.yandexcloud.net/xray/momo-store/momo-h.jpg">


## Деплой

Деплой в Prod: https://momo.vnaz.site приложения выполняетя через ArgoCD в кластер Kubernetes (развернут в Yandex Cloud), каждые 3 минуты проверяет в GitLab ветку main, директорию Helm (charts) и автоматоматческий деплоит если есть изменения.

Деплой в Stage: https://momo-stage.vnaz.site

ArgoCD Application:
- Prod : app-prod.yaml
- Stage: app-stage.yaml

<img width="900" alt="image" src="https://storage.yandexcloud.net/xray/momo-store/ArgoCD.jpg">


## Инфраструктура

Для GitLab настроил gitlab-runner в k8s, [документация по настройке](https://cloud.yandex.ru/docs/managed-gitlab/tutorials/gitlab-containers#runners).

```
helm install --namespace default gitlab-runner -f values.yaml gitlab/gitlab-runner
```

В директории **infra** хранятся манифесты по разварачиванию инфраструктуры через Terraform(K8s, Object Storage), а также чарты приложения по ArgoCD и Monitoring.

Изображения пельменной для проекта хранятся в Object Storage.

В Cloud DNS настроеные следующие адреса:

- Prod: https://momo.vnaz.site
- Stage: https://momo-stage.vnaz.site
- ArgoCD: https://argocd.vnaz.site
- Prometheus: https://prometheus.vnaz.site
- Grafana: https://grafana.vnaz.site

## Terraform
Состояние Terraform state (terraform.tfstate) хранится в [Object Storage](https://storage.yandexcloud.net/xray-terrafom/terraform.tfstate).

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


Полная инструкция по разварачиванию всей инфраструктуры для Terraform в [Yandex Cloud Provider](https://terraform-eap.website.yandexcloud.net/docs/providers/yandex/index.html).

## Подготовка k8s кластера

Установка Ingress-контроллера NGINX с менеджером для сертификатов Let's Encrypt по [инcтрукции](https://cloud.yandex.ru/docs/managed-kubernetes/tutorials/ingress-cert-manager) от Yandex Cloud:

```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx && \
helm repo update && \
helm install ingress-nginx ingress-nginx/ingress-nginx
```

Установить менеджер сертификатов Сert Manager:

```
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.9.1/cert-manager.yaml
```

Создать объект ClusterIssuer:

```
kubectl apply -f acme-issuer.yml
```

## Установка ArgoCD

Доступ в ArgoCD: https://argocd.vnaz.site

```
cd infra/argocd
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -n argocd -f argocd-ingres-all.yaml
kubectl apply -n argocd -f private-repo.yaml
cd application/
kubectl apply -n argocd -f app-prod.yaml
kubectl apply -n argocd -f app-stage.yaml
```

## Установка Grafana

Доступ в Grafana: https://grafana.vnaz.site


```
cd infra/monitoring/grafana
helm install --atomic grafana ./
```

## Установка Loki

```
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install --atomic loki grafana/loki-stack
```

DataSource: `http://loki:3100`

## Установка Prometheus

Доступ в Prometheus https://prometheus.vnaz.site

```
cd infra/monitoring/prometheus
helm install --atomic prometheus ./
```

DataSource: `http://prometheus:9090`

## Экспортер 
Для frontend на NGINX добавлен экспортер [NGINX Prometheus Exporter](https://hub.docker.com/r/nginx/nginx-prometheus-exporter).

Документация по настройке NGINX Prometheus Exporter для  NGINX Ingress Controller описана [тут](https://docs.nginx.com/nginx-ingress-controller/logging-and-monitoring/prometheus/).


## Мониторинг

##### Grafana

<img width="900" alt="image" src="https://storage.yandexcloud.net/xray/momo-store/grafana.jpg">

##### Loki

<img width="900" alt="image" src="https://storage.yandexcloud.net/xray/momo-store/Loki.jpg">

##### Prometheus

<img width="900" alt="image" src="https://storage.yandexcloud.net/xray/momo-store/prometheus.jpg">

##### Yandex Cloud Monitoring

<img width="900" alt="image" src="https://storage.yandexcloud.net/xray/momo-store/monitoring.jpg">

## Тестирование 
Тестирование в CI с помощью SAST(eslint-sast, gosec-sast, nodejs-scan-sast, semgrep-sast).

Анализ кода в SonarQube.

- [backend](https://sonarqube.praktikum-services.ru/dashboard?id=09_VITALY_NAZAROV_BACKEND_M)
- [frontend](https://sonarqube.praktikum-services.ru/dashboard?id=09_VITALY_NAZAROV_FRONTEND_M)


##### SonarQube

<img width="900" alt="image" src="https://storage.yandexcloud.net/xray/momo-store/sonarqube.jpg">

## Хранение Helm чартов
Helm чарты хранятся в репозитарии GitLab Package Registry и [Nexus](https://nexus.praktikum-services.ru/#browse/browse:momo-store-vitaly-nazarov-09:momo-store).

##### GitLab Package Registry
<img width="900" alt="image" src="https://storage.yandexcloud.net/xray/momo-store/GitLab-Package-Registry-Helm-charts.jpg">

##### Nexus
<img width="900" alt="image" src="https://storage.yandexcloud.net/xray/momo-store/nexus.jpg">

## Уведомления о новых релизах
Уведомления о релизах отправляются в мессенджер [Telegram](https://t.me/+syGG5yTYVpsyMjA6).

## Алерты
Алерты о сбое сервисов настроены с помощь [Yandex Monitoring](https://cloud.yandex.ru/docs/monitoring/). 

<img width="900" alt="image" src="https://storage.yandexcloud.net/xray/momo-store/alerts2.jpg">

<img width="900" alt="image" src="https://storage.yandexcloud.net/xray/momo-store/alerts.jpg">



## Версионирование

Версия приложения формируется из переменной `VERSION` в пайплайне - `1.0.${CI_PIPELINE_ID}`
```
variables:
    VERSION: 1.0.${CI_PIPELINE_ID}
```

При сборке каждый образ frontend и backend получает tag с номером версии приложения и публикуется в GitLab Container Registry.

<img width="900" alt="image" src="https://storage.yandexcloud.net/xray/momo-store/Docker.jpg">
<img width="900" alt="image" src="https://storage.yandexcloud.net/xray/momo-store/Docker2.jpg">
