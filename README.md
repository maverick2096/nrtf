# Terraform: Core Azure Stack — Explicit Inputs Style (no cfg)


- All values in `terraform.tfvars`
- Modules use **explicit inputs** (no single cfg object)
- Boolean toggles; defaults set to avoid prompts

**Included**
- Resource Group, ACR, Key Vault, Log Analytics, VM (Linux), Service Bus, App Service, Storage
**Use**
```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```
Set any `build_*` to `false` to skip creating that resource. Ensure dependencies like `vm_subnet_id` are present if enabling VM.
