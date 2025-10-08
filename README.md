# Neo DevOps Terraform & Kubernetes Project

Цей проєкт створює базову інфраструктуру в AWS за допомогою Terraform та розгортає Django-додаток у Kubernetes через Helm.

Інфраструктура включає:

- **S3 бакет** + **DynamoDB** для зберігання та блокування Terraform state.
- **VPC** з публічними та приватними підмережами, інтернет-шлюзом та маршрутами.
- **ECR репозиторій** для зберігання Docker образів.
- **EKS кластер** для запуску Kubernetes.
- **Helm чарти** для деплою Django-додатку.
- **RDS / Aurora** для зберігання даних додатку.

---

## 📂 Структура проєкту

```
neo-devops/
├── main.tf
├── backend.tf
├── outputs.tf
│
├── modules/
│ ├── s3-backend/
│ ├── vpc/
│ ├── ecr/
│ ├── eks/
│ ├── rds/ # ✅ Новий модуль RDS
│ │ ├── rds.tf
│ │ ├── aurora.tf
│ │ ├── shared.tf
│ │ ├── variables.tf
│ │ └── outputs.tf
│ └── jenkins/
│ └── argo_cd/
├── charts/
│ └── django-app/
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

🔹 rds ✅

Модуль для створення бази даних, який універсально працює як для звичайної RDS instance, так і для Aurora Cluster.

### Основні можливості:

1. use_aurora = true → створює Aurora Cluster + writer.

2. use_aurora = false → створює стандартну aws_db_instance.

3. Автоматично створює:

- DB Subnet Group

- Security Group

- Parameter Group з базовими налаштуваннями (max_connections, log_statement, work_mem).

4. Параметри, які можна змінювати через змінні:

- engine (тип бази: postgres, mysql тощо)

- engine_version

- instance_class

- multi_az для RDS

5. Підтримка багаторазового використання модуля з мінімальними змінами.

### Приклад використання модуля:
```bash
module "rds" {
  source        = "./modules/rds"
  use_aurora    = true
  engine        = "aurora-postgresql"
  engine_version = "15.2"
  instance_class = "db.r6g.large"
  multi_az      = true
  db_name       = "myappdb"
  username      = "admin"
  password      = "SuperSecret"
  vpc_id        = module.vpc.vpc_id
  subnet_ids    = module.vpc.private_subnets
}
```
### Змінні модуля (variables.tf):
| Змінна           | Тип    | Опис                                                   |
| ---------------- | ------ | ------------------------------------------------------ |
| `use_aurora`     | bool   | Якщо true → Aurora Cluster, якщо false → RDS instance  |
| `engine`         | string | Тип БД (`postgres`, `mysql`, `aurora-postgresql` тощо) |
| `engine_version` | string | Версія БД                                              |
| `instance_class` | string | Тип інстансу AWS RDS                                   |
| `multi_az`       | bool   | Множинна зона для RDS instance                         |
| `db_name`        | string | Ім'я бази даних                                        |
| `username`       | string | Логін адміністратора                                   |
| `password`       | string | Пароль адміністратора                                  |
| `vpc_id`         | string | ID VPC для DB                                          |
| `subnet_ids`     | list   | Список приватних subnet IDs для DB Subnet Group        |

### Outputs (outputs.tf):
- db_endpoint – адреса для підключення до бази.

- db_port – порт бази.

- db_cluster_id – ID Aurora Cluster (якщо use_aurora=true).

- db_instance_id – ID RDS instance (якщо use_aurora=false).



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
