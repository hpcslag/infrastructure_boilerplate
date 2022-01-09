# Terraform infrastructure boilerplate

the module already contains:

 - bucket
 - cloudflare_dns
 - container-pipeline
 - deployment_group
 - ecr
 - eks_node_group
 - elasticache
 - k8s-helm-charts
 - large-build-pipeline
 - peering
 - pipeline
 - rds-mysql
 - rds-postgresql
 - rds-postgresql-cluster
 - server
 - server_with_rds
 - web

## Initialize

The project is initialize by terragrunt, please enter command:

```
terragrunt init
```

## Apply setting

```
terraform init
terraform plan -var-file=vars/common.yml
terraform apply
```

