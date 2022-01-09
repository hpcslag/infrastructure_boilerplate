# terraform_module
my terraform module for reference

# First time setup

must setup by `terragrunt init`, terragurnt will auto create `backend.tf`, `provider.tf`

# Terraform Commands

`**terraform init**`: if using any new module in `main.tf`, then needs to run `terraform init` first.

`**terraform plan**`: everytime changes the terraform files needs to run this command.

`**terraform plan -var-file xxx.yml**`: if you want to apply the var files, using this flag bring out.

`**terraform apply -auto-approve -parallelism=100**`: everytime want to changes the cloud resource needs to apply it.

