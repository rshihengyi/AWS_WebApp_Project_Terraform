# // IAM role for EKS worker nodes

# /* Minimum Parameters: 
#     - name:                 role name
#     - assume_role_policy:   trust policy (who can wear the hat)
# */
# resource "aws_iam_role" "worker_nodes" {
#   name = "Node-Join-Cluster"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# /* Minimum Parameters: 
#     - role:                 what role to attach permissions to
#     - policy_arn:           the iam policy arn
# */
# resource "aws_iam_role_policy_attachment" "node_pa" {
#   role       = aws_iam_role.worker_nodes.name
#   policy_arn = aws_iam_policy.node_permissions.arn
# }


# /* Minimum Parameters: 
#     - name:                 custom name for policy list
#     - policy:               (list of permissions to allow for whoever wears the hat)
# */
# // Source: https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonEKSWorkerNodePolicy.html
# resource "aws_iam_policy" "node_permissions" { //From AmazonEKSWorkerNodePolicy
#   name = "Node-Permissions-List"
#   policy = jsonencode({

#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Sid" : "WorkerNodePermissions",
#         "Effect" : "Allow",
#         "Action" : [
#           "ec2:DescribeInstances",
#           "ec2:DescribeInstanceTypes",
#           "ec2:DescribeRouteTables",
#           "ec2:DescribeSecurityGroups",
#           "ec2:DescribeSubnets",
#           "ec2:DescribeVolumes",
#           "ec2:DescribeVolumesModifications",
#           "ec2:DescribeVpcs",
#           "eks:DescribeCluster",
#           "eks-auth:AssumeRoleForPodIdentity"
#         ],
#         "Resource" : "*"
#       }
#     ]
#   })
# }