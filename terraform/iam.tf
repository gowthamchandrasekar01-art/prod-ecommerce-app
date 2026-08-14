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
