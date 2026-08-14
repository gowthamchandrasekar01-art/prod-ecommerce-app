resource "aws_kms_key" "s3" {
  description         = "KMS key for encrypting production e-commerce S3 assets"
  enable_key_rotation = false
}

resource "aws_kms_alias" "s3" {
  name          = "alias/prod-ecommerce-s3-key"
  target_key_id = aws_kms_key.s3.key_id
}
