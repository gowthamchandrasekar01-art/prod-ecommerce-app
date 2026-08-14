resource "aws_iam_role" "ec2" {
  name = "prod-ecommerce-ec2-role"

  description = "Allows EC2 instances to call AWS services on your behalf. IAM role for production e-commerce application EC2 instances"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2" {
  name = "prod-ecommerce-ec2-role"
  role = aws_iam_role.ec2.name
}
resource "aws_iam_policy" "s3_assets" {
  name = "prod-ecommerce-s3-assets-access"

  description = "Least-privilege access for the production e-commerce application to S3 assets and KMS encryption."

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "ListAssetsBucket"
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = "arn:aws:s3:::prod-ecommerce-assets-809311528378-ap-south-1-an"
      },
      {
        Sid    = "ManageAssetObjects"
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]

        Resource = "arn:aws:s3:::prod-ecommerce-assets-809311528378-ap-south-1-an/*"
      },
      {
        Sid    = "UseS3KmsKey"
        Effect = "Allow"

        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey"
        ]

        Resource = "arn:aws:kms:ap-south-1:809311528378:key/e83a80b6-d4ad-4394-978d-0e91587551e9"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "s3_assets" {
  role       = aws_iam_role.ec2.name
  policy_arn = aws_iam_policy.s3_assets.arn
}

resource "aws_iam_role_policy" "db_secret_read" {
  name = "prod-ecommerce-db-secret-read"
  role = aws_iam_role.ec2.name

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "secretsmanager:GetSecretValue"
        ]

        Resource = "arn:aws:secretsmanager:ap-south-1:809311528378:secret:rds!db-ec91278d-0b6e-48e6-b85b-6be2e0e872b4-I7hVby"
      }
    ]
  })
}
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]
}

resource "aws_iam_role" "github_actions" {
  name = "prod-ecommerce-github-actions"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }

        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }

          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:gowthamchandrasekar01-art/prod-ecommerce-app:ref:refs/heads/main"
          }
        }
      }
    ]
  })
}
resource "aws_iam_role_policy" "github_actions_deploy" {
  name = "prod-ecommerce-github-actions-deploy"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "DeployFrontendToS3"
        Effect = "Allow"

        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]

        Resource = "arn:aws:s3:::prod-ecommerce-frontend-809311528378-ap-south-1-an"
      },

      {
        Sid    = "ManageFrontendObjects"
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]

        Resource = "arn:aws:s3:::prod-ecommerce-frontend-809311528378-ap-south-1-an/*"
      },

      {
        Sid    = "InvalidateCloudFront"
        Effect = "Allow"

        Action = [
          "cloudfront:CreateInvalidation"
        ]

        Resource = "arn:aws:cloudfront::809311528378:distribution/E1EVTNHGR00ED1"
      },

      {
        Sid    = "UseRunShellScriptDocument"
        Effect = "Allow"

        Action = [
          "ssm:SendCommand"
        ]

        Resource = "arn:aws:ssm:ap-south-1::document/AWS-RunShellScript"
      },

      {
        Sid    = "SendDeploymentCommandsToAppInstances"
        Effect = "Allow"

        Action = [
          "ssm:SendCommand"
        ]

        Resource = "arn:aws:ec2:ap-south-1:809311528378:instance/*"

        Condition = {
          StringEquals = {
            "ssm:resourceTag/Name" = "prod-ecommerce-app-server"
          }
        }
      },

      {
        Sid    = "ReadDeploymentCommandStatus"
        Effect = "Allow"

        Action = [
          "ssm:GetCommandInvocation",
          "ssm:ListCommandInvocations",
          "ssm:DescribeInstanceInformation"
        ]

        Resource = "*"
      },

      {
        Sid    = "DescribeDeploymentTargets"
        Effect = "Allow"

        Action = [
          "ec2:DescribeInstances",
          "autoscaling:DescribeAutoScalingGroups"
        ]

        Resource = "*"
      }
    ]
  })
}
