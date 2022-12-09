#region - Generation random string
    /**
     * https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string
    */
    resource "random_string" "random" {
        length           = 5
        lower            = true
        upper            = false     
        numeric          = false
        special          = false
    }

#endregion

#region - Create a Bucket S3 
    /**
    * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
    * https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html
    * https://docs.aws.amazon.com/AmazonS3/latest/userguide/acl-overview.html#canned-acl
    */
    resource "aws_s3_bucket" "b_s3" {
        bucket  = "b-s3-${random_string.random.result}"
        tags = {
            Name        = "Bucket-S3"
            Environment = "developer"
        }
    }
#endregion

#region - Create a ACL
    /**
     * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl
    */
    resource "aws_s3_bucket_acl" "acl" {
        bucket = aws_s3_bucket.b_s3.id
        acl    = var.acl
    }
#endregion

#region - Create a Website Static Configuration
    /**
     * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration     
    */
    resource "aws_s3_bucket_website_configuration" "Website_config" {
        bucket = aws_s3_bucket.b_s3.bucket

        index_document {
            suffix = "index.html"
        }
    }
#endregion

#region - Create a Bucket Policy
    /**
     * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy
      * https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteAccessPermissionsReqd.html
    */
    resource "aws_s3_bucket_policy" "allow_access_public_all" {
     bucket = aws_s3_bucket.b_s3.id
     policy = jsonencode(
        {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Sid": "PublicReadGetObject",
                    "Effect": "Allow",
                    "Principal": "*",
                    "Action": [
                        "s3:GetObject"
                    ],
                    "Resource": [
                        "arn:aws:s3:::${aws_s3_bucket.b_s3.bucket}/*"
                    ]
                }
            ]
        }
     )
    }
#endregion

#region - Bucket S3 upload file
    /**
     * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object
     * https://www.ibm.com/docs/en/aspera-on-cloud?topic=SS5W4X/dita/content/aws_s3_content_types.htm
     * https://engineering.statefarm.com/blog/terraform-s3-upload-with-mime/
    */
    resource "aws_s3_object" "object_upload" {
        bucket          = aws_s3_bucket.b_s3.id
        key             = "index.html"
        content_type    = "text/html" # Sure can't download file when acess endpoint bucket address
        source          = "${path.module}/files/index.html"
    }
#endregion

#region - Cloudfront
    /**
     * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution
     * https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/PriceClass.html
    */
    resource "aws_cloudfront_distribution" "s3_distribution" {
        origin {
            domain_name                = aws_s3_bucket.b_s3.bucket_regional_domain_name
            origin_id                  = aws_s3_bucket.b_s3.bucket
        }

        enabled                        = true
        is_ipv6_enabled                = true
        comment                        = "Cloudfront - S3 Bucket"

        default_cache_behavior {
            allowed_methods            = ["GET", "HEAD"]
            cached_methods             = ["GET", "HEAD"]
            target_origin_id           = aws_s3_bucket.b_s3.bucket
            cache_policy_id            = aws_cloudfront_cache_policy.cn_cache_policy.id
            compress                   = true 
            viewer_protocol_policy     = var.protocol_polocity_method
        }

        price_class                    = var.price_class_type

        restrictions {
            geo_restriction {
                restriction_type       = var.restriction_type
                locations              = []
            }
        }

        tags = {
            Name                       = "CloudFront_S3"
            Environment                = "developer"
        }

        viewer_certificate {
            cloudfront_default_certificate = true
        }      

    }
#endregion

#region - CloudFront - Cache Policy
    /**
     * https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-cache-policies.html
     * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_cache_policy
    */
    resource "aws_cloudfront_cache_policy" "cn_cache_policy" {
        name        = "Custom-CachingOptimized"
        comment     = "This policy is designed to optimize cache efficiency by minimizing the values that CloudFront includes in the cache key"
        default_ttl = 86400 #(24 hours).
        max_ttl     = 31536000 #(365 days).
        min_ttl     = 1
        parameters_in_cache_key_and_forwarded_to_origin {
            cookies_config {
                cookie_behavior = "none"
            }
            headers_config {
                header_behavior = "none"
            }
            query_strings_config {
                query_string_behavior = "none"
            }
        }
    }
#endregion