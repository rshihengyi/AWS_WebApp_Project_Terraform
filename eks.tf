module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "My-Cluster"
  kubernetes_version = "1.36"

  addons = {
    coredns = {
      before_compute = true
     # addon_version = "v1.14.3-eksbuild.3"
      resolve_conflicts_on_create = "OVERWRITE" // 
     # most_recent = "true"
    }
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
  }

  # Optional
  endpoint_public_access = true

  # Optional: Adds the current caller identity (person who created tf code) as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id = aws_vpc.my_vpc.id
  subnet_ids = [
    aws_subnet.private_1a.id,
    aws_subnet.private_1b.id
  ]

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    node_group = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t2.small"]

      min_size     = 2 //total amount of running worker nodes spread across the subnets. 
      max_size     = 4
      desired_size = 2
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
