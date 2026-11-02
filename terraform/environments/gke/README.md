# GKE environment

This environment contains an example Terraform-managed Google Kubernetes Engine cluster configuration. GKE provisioning has **not** been performed or validated.

From this directory:

```bash
terraform init
terraform fmt -check
terraform validate
terraform plan -var="project_id=YOUR_PROJECT_ID" -var="admin_cidr=YOUR_PUBLIC_IP/32"
```

**Costs:** GKE clusters, nodes, disks, networking and egress can incur significant costs. Review billing estimates and the plan before applying. Clean up with `terraform destroy` after capturing legitimate evidence.

This example uses the default VPC, with administrator CIDR-restricted GKE API access and Workload Identity Federation for GKE. Supply a trusted external IPv4 CIDR for admin access. Production deployment should also use a private purpose-built network, carefully scoped node service accounts, and a versioned module. The node pool is a small, non-production configuration.
