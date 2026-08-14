resource "aws_cloudfront_origin_access_control" "frontend" {
  name                              = "oac-prod-ecommerce-frontend-809311528378-ap-south-1--mspqw1wl1qr"
  description                       = "Created by CloudFront"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "frontend" {
  enabled             = true
  comment             = "Production e-commerce frontend"
  default_root_object = "index.html"
  price_class         = "PriceClass_All"
  is_ipv6_enabled     = true

  aliases = [
    "shopnest.gowthamcloud.site"
  ]

  origin {
    domain_name              = "prod-ecommerce-frontend-809311528378-ap-south-1-an.s3.ap-south-1.amazonaws.com"
    origin_id                = "prod-ecommerce-frontend-809311528378-ap-south-1-an.s3.ap-south-1.amazonaws.com-mspqtiibemh"
    origin_access_control_id = aws_cloudfront_origin_access_control.frontend.id
  }

  default_cache_behavior {
    target_origin_id       = "prod-ecommerce-frontend-809311528378-ap-south-1-an.s3.ap-south-1.amazonaws.com-mspqtiibemh"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = [
      "GET",
      "HEAD"
    ]

    cached_methods = [
      "GET",
      "HEAD"
    ]

    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    compress        = true
  }

  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:809311528378:certificate/7ec9f60f-d847-4159-814f-af5b9b0d0e96"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  web_acl_id = "arn:aws:wafv2:us-east-1:809311528378:global/webacl/CreatedByCloudFront-405436e1/a119bc40-cba5-4190-95af-73c85eeeecb8"

  tags = {
    Name = "prod-ecommerce-frontend"
  }

  # Keep these Terraform-only lifecycle values from affecting the imported distribution.
  lifecycle {
    ignore_changes = [
      retain_on_delete,
      wait_for_deployment,
    ]
  }
}
