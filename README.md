# Neo DevOps Terraform & Kubernetes Project

Цей проєкт реалізує повну DevOps-інфраструктуру в AWS з використанням Terraform та Kubernetes (EKS) 
для автоматизації CI/CD, розгортання застосунків та моніторингу.

## 🚀 Основна мета

### Інфраструктура забезпечує:

- **EKS кластер** для Kubernetes-додатків

- **Jenkins** для CI/CD-процесів

- **Argo CD** для GitOps-деплою застосунків

- **RDS / Aurora** для бази даних

- **ECR** для зберігання Docker-образів

- **Prometheus + Grafana** для моніторингу

- **S3 + DynamoDB** для бекенду Terraform state

- **VPC** з публічними та приватними підмережами

---

## 📂 Структура проєкту

```
neo-devops/
├── main.tf
├── backend.tf
├── outputs.tf
│
├── modules/
│ ├── s3-backend/        # S3 + DynamoDB для state
│ ├── vpc/               # VPC, сабнети, маршрути
│ ├── ecr/               # ECR репозиторій
│ ├── eks/               # EKS кластер + драйвер EBS CSI
│ ├── rds/               # RDS / Aurora
│ ├── jenkins/           # Jenkins через Helm
│ ├── argo_cd/           # Argo CD + чарти застосунків
│ └── monitoring/        # Prometheus + Grafana (Helm)
│
├── charts/
│ └── django-app/        # Helm чарт Django-додатку
│
└── Django/
   ├── app/
   ├── Dockerfile
   ├── Jenkinsfile
   └── docker-compose.yaml
```

---

## ⚙️ Команди Terraform

   ```bash
   terraform init         # 1. Ініціалізація бекенду (S3 + DynamoDB)
   terraform plan         # 2. Перевірка плану
   terraform apply        # 3. Розгортання всієї інфраструктури
   terraform destroy      # 4. Повне видалення ресурсів
   ```

## 🔧 Після розгортання
### Перевірка стану Kubernetes

```bash
   aws eks --region <region> update-kubeconfig --name <cluster_name>
   kubectl get nodes
   kubectl get all -n jenkins
   kubectl get all -n argocd
   kubectl get all -n monitoring
   ```

## 🌐 Перевірка доступності сервісів

| Сервіс     | Команда Port Forward                                               | Порт доступу                                     | Призначення     |
| ---------- | ------------------------------------------------------------------ | ------------------------------------------------ | --------------- |
| Jenkins    | `kubectl port-forward svc/jenkins 8080:8080 -n jenkins`            | [http://localhost:8080](http://localhost:8080)   | CI/CD пайплайни |
| Argo CD    | `kubectl port-forward svc/argocd-server 8081:443 -n argocd`        | [https://localhost:8081](https://localhost:8081) | GitOps деплой   |
| Grafana    | `kubectl port-forward svc/grafana 3000:80 -n monitoring`           | [http://localhost:3000](http://localhost:3000)   | Моніторинг      |
| Prometheus | `kubectl port-forward svc/prometheus-server 9090:80 -n monitoring` | [http://localhost:9090](http://localhost:9090)   | Метрики         |



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

🔹 rds / aurora

- Створює базу даних: RDS або Aurora.

- Автоматично створює:

   DB Subnet Group

   Security Group

   Parameter Group

- Підтримує змінні:

   use_aurora (true/false)

   engine, engine_version

   instance_class, multi_az

🔹 jenkins

- Розгортає Jenkins у namespace jenkins через Helm.

- Має власний values.yaml для налаштування агентів, ресурсів і pipeline.

- Після деплою доступ через kubectl port-forward.

🔹 argo_cd

- Розгортає Argo CD через Helm у namespace argocd.

- Має Helm-підкаталог charts/ із:

   application.yaml — визначення застосунків

   repository.yaml — підключення Git-репозиторію

- Автоматично створює app для Django через GitOps.

🔹 monitoring

- Розгортає Prometheus + Grafana через Helm.

- Збирає метрики з Kubernetes та додатків.

- Grafana Dashboard відображає стан кластеру, CPU, RAM, мережу.


## 🧩 Django-додаток

- Зберігається у каталозі Django/

- Має Dockerfile та Jenkinsfile для CI/CD

- Розгортається через Helm-чарт у charts/django-app/

- Використовує ConfigMap із values.yaml для параметрів середовища

- Має autoscaling через hpa.yaml


## 🔍 Моніторинг і метрики

- Prometheus збирає метрики з EKS, pod’ів і додатків.

- Grafana візуалізує:

- Навантаження CPU/RAM

- Стан pod’ів

- Відмови деплойментів

- Стан БД та сервісів


## ✅ Вимоги

- AWS акаунт з налаштованими credentials.

- Terraform v1.3+.

- AWS CLI.

- Helm 3+.

- Kubectl 1.25+.

- Docker (для збірки та пушу образів).


## 🔑 Outputs

Після виконання terraform apply ви отримаєте:

- ecr_repository_url — адреса для пушу Docker-образів

- rds_endpoint — підключення до бази даних

- eks_cluster_name — ім’я Kubernetes-кластера

- jenkins_url, argo_cd_url, grafana_url — доступи до сервісів

- s3_bucket_name, dynamodb_table — бекенд Terraform
