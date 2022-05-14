### Terraform

include:

- VPC, with subnet, route table, internet gate, nat gateway
- EC2 nginx server,keypair to test connection, on subnet 1c-private
- AWS Managed Microsoft AD stand, user Admin
- An ACM certificate, use terraform import command

variable: copy and edit `tfvars.example` file

run:

```
terraform apply -var-file dev.tfvar
```
