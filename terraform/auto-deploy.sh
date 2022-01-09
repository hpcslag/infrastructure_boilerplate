set -e

terraform init
terraform plan
terraform apply -auto-approve -parallelism=100