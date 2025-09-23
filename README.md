# Neo DevOps Terraform & Kubernetes Project

Цей проєкт створює базову інфраструктуру в AWS за допомогою Terraform та розгортає Django-додаток у Kubernetes через Helm.

Інфраструктура включає:

- **S3 бакет** + **DynamoDB** для зберігання та блокування Terraform state.
- **VPC** з публічними та приватними підмережами, інтернет-шлюзом та маршрутами.
- **ECR репозиторій** для зберігання Docker образів.
- **EKS кластер** для запуску Kubernetes.
- **Helm чарти** для деплою Django-додатку.

---

## 📂 Структура проєкту

```
neo-devops/
├── main.tf # Головний файл для підключення модулів
├── backend.tf # Налаштування бекенду для Terraform state (S3 + DynamoDB)
├── outputs.tf # Загальні виводи ресурсів
│
├── modules/ # Каталог з усіма модулями
│ ├── s3-backend/ # Модуль для S3 та DynamoDB
│ │ ├── s3.tf
│ │ ├── dynamodb.tf
│ │ ├── variables.tf
│ │ └── outputs.tf
│ │
│ ├── vpc/ # Модуль для VPC
│ │ ├── vpc.tf
│ │ ├── routes.tf
│ │ ├── variables.tf
│ │ └── outputs.tf
│ │
│ ├── ecr/ # Модуль для ECR
│ │ ├── ecr.tf
│ │ ├── variables.tf
│ │ └── outputs.tf
│ │
│ └── eks/ # Модуль для EKS
│ ├── eks.tf
│ ├── variables.tf
│ └── outputs.tf
│
├── charts/ # Helm чарти
│ └── django-app/
│ ├── templates/
│ │ ├── deployment.yaml
│ │ ├── service.yaml
│ │ ├── configmap.yaml
│ │ └── hpa.yaml
│ ├── Chart.yaml
│ └── values.yaml # ConfigMap зі змінними середовища
```

---

## ⚙️ Команди Terraform

1. Ініціалізація Terraform та бекенду:

   ```bash
   terraform init
   ```

2. Перевірка плану змін:
   ```bash
   terraform plan
   ```
3. Створення інфраструктури:
   ```bash
   terraform apply
   ```
4. Видалення всієї інфраструктури:
   ```bash
   terraform destroy
   ```

## 🏗️ Деплой Django в Kubernetes через Helm

1. Перевірка доступності Kubernetes кластера (EKS):

   ```bash
   aws eks --region <region> update-kubeconfig --name <cluster_name>
   kubectl get nodes
   ```

2. Деплой Django-додатку:

   ```bash
   helm upgrade --install django-app ./charts/django-app -n default -f ./charts/django-app/values.yaml
   ```
3. Перевірка стану Pods:

   ```bash
   kubectl get pods -n default -l app=django-app
   ```
4. Перевірка сервісу та зовнішньої адреси:
   ```bash
   kubectl get svc -n default
   ```

## 📦 Модулі

🔹 s3-backend

- Створює S3 бакет для зберігання Terraform state файлу.

- Створює DynamoDB таблицю для блокування (lock) state при одночасних змінах.

- Гарантує безпечну та централізовану роботу з Terraform.

🔹 vpc

- Створює VPC з CIDR 10.0.0.0/16.

- Публічні підмережі:

- Доступ до інтернету через Internet Gateway.

- Призначені для ресурсів, яким потрібен публічний доступ.

- Приватні підмережі:

- Використовуються для внутрішніх сервісів (наприклад, баз даних).

- Створює маршрути та асоціює їх з підмережами.

🔹 ecr

- Створює AWS Elastic Container Registry (ECR) репозиторій.

- Використовується для зберігання Docker образів.

- Увімкнено автоматичне сканування образів на вразливості.

🔹 eks

- Створює EKS кластер для запуску Kubernetes.

- Виводить kubeconfig для підключення.

- Підтримує масштабування worker-нодів.

## ✅ Вимоги

AWS акаунт з налаштованими credentials.

Terraform v1.3+.

AWS CLI.

Helm 3+.

Kubectl 1.25+.

Docker (для збірки та пушу образів).

## 🔑 Outputs

Після виконання terraform apply ви отримаєте:

ECR URL — адреса репозиторію для пушу образів.

VPC ID та сабнети.

Назву S3 бакету та DynamoDB таблиці для бекенду.
