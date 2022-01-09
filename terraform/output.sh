terraform output -json my_server | jq -r '.[] | "Host \(.namespace)
    Hostname \(.public_ip)
    User ubuntu
    IdentityFile ~/.ssh/id_rsa"' >> ssh.config

echo "[my_server]" >> hosts
terraform output -json my_server | jq -r '.[] | "\(.namespace)"' >> hosts


mv ./ssh.config ../ansible/ssh.config
mv ./hosts ../ansible/hosts


#### K8S Connection Setting
echo -n "---
apiVersion: v1
kind: Secret
metadata:
  name: my_secrets
  namespace: my_server_production
type: Opaque
data:
  DATABASE_HOST: $(terraform output -raw my_server_db_instance_address | base64 -w0)
" > "secret.yaml"
mv ./secret.yaml ../kubernetes/services/my_server/secret.yaml
####