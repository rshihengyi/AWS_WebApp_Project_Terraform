# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy

# IAM Role for SSM Agent
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

# IAM Role for Terraform
# Get AWS account id
data "aws_caller_identity" "current" {}

resource "aws_iam_role" "git_ssm_tf" {
  name = "GitHubActions-Trust-Policy-TF"
  assume_role_policy = jsonencode({ # Trust Policy
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"

        Effect = "Allow"
        #Resource = "*"

        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
        }

        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.GITHUB_USERNAME}/${var.TF_REPO}:*"
          }
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

# Custom Permission Policy
resource "aws_iam_policy" "git_permission_policies_tf" {
  name = "GitHubActions-Custom-Permission-Policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:*",
          "elasticloadbalancing:*",
          "acm:*",
          "route53:*",
          "s3:*",
          "iam:*"
        ]
        Resource = "*"
      }
    ]
  })

  #   policy = <<EOT
  # {
  #   "Version": "2012-10-17",
  #   "Statement": [
  #     {
  #       "Effect": "Allow",
  #       "Action": [
  #         "iam:*"
  #       ]
  #       "Resource": "*"
  #     }
  #   ]
  # }
  #     EOT

}

resource "aws_iam_role_policy_attachment" "git_attach_policies" {
  role       = "Access_TF_resources_arch1"
  policy_arn = aws_iam_policy.git_permission_policies_tf.arn
}

# IAM Role for WebApp Deployment
resource "aws_iam_role" "git_ssm_app" {
  name = "GitHubActions-Trust-Policy-WA"
  assume_role_policy = jsonencode({ # Trust Policy
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"

        Effect = "Allow"
        #Resource = "*"

        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
        }

        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.GITHUB_USERNAME}/${var.APP_REPO}:*"
          }
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}


resource "aws_iam_policy" "github_webapp_deploy_policy" {
  name = "github-actions-webapp-deploy-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:SendCommand",
          "ssm:GetCommandInvocation",
          "ssm:ListCommandInvocations",
          "ec2:DescribeInstances"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_webapp_deploy_attach" {
  role       = aws_iam_role.git_ssm_app.name
  policy_arn = aws_iam_policy.github_webapp_deploy_policy.arn
}