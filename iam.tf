# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy


resource "aws_iam_role" "ec2_ssm" {
  name = "SSM-Command"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "webapp-ec2-instance-profile"
  role = aws_iam_role.ec2_ssm.name
}

# Get AWS account id
data "aws_caller_identity" "current" {}

resource "aws_iam_role" "git_ssm" {
  name = "GitHubActions-Trust-Policy"
  assume_role_policy = jsonencode({ # Trust Policy
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"

        Effect = "Allow"
        #Resource = "*"

        Principal = {
          Federated = "arn:aws:iam::536984667329:oidc-provider/token.actions.githubusercontent.com"
        }

        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" = "repo:rshihengyi/AWS_WebApp_Project:*"
            "token.actions.githubusercontent.com:sub" = "repo:rshihengyi/AWS_WebApp_Project_Terraform:*"
          }
        }
      }
    ]
  })
}

# Custom Permission Policy
resource "aws_iam_policy" "git_permission_policies" {
  name   = "GitHubActions-Custom-Permission-Policy"
  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:*"
      ],
      "Resource": "*"
    }
  ]
}

    EOT

}

resource "aws_iam_role_policy_attachment" "git_attach_policies" {
  role       = "Access_TF_resources_arch1"
  policy_arn = aws_iam_policy.git_permission_policies.arn
}