/*
    Need Helm charts for:
        - Ingress Controller (AWS load balancer controller)
        - ExternalDNS
*/

resource "helm_release" "ingress_controller" {
  name       = "aws-lb-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "3.5.0"
  namespace  = "kube-system"

  /* need to specify:
    - clusterName
    - region
    - vpcId
    - serviceAccount.create
    - serviceAcount.name
*/

  set = [
    {
      name  = "clusterName"
      value = module.eks.cluster_name
    },
    {
      name  = "region"
      value = var.my_region
    },
    {
      name  = "vpcId"
      value = aws_vpc.my_vpc.id
    },
    {
      name  = "serviceAccount.create" // 
      value = true
    },
    {
      name  = "serviceAccount.name"
      value = "aws-load-balancer-controller"
    }
  ]
}


resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  version    = "1.21.1"
  namespace  = "kube-system"

  set = [
    {
      name  = "clusterName"
      value = module.eks.cluster_name
    },
    {
      name  = "region"
      value = var.my_region
    },
    {
      name  = "vpcId"
      value = aws_vpc.my_vpc.id
    },
    {
      name  = "serviceAccount.create"
      value = true
    },
    {
      name  = "serviceAccount.name"
      value = "external-dns"
    }
  ]
}