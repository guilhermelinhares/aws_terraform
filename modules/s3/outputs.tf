#region - S3
    output "web_s3_endpoint" {
        description = "Endpoint S3 Bucket"
        value       = aws_s3_bucket_website_configuration.Website_config.website_endpoint
    }
#endregion

#region - CloudFront
    output "cn_domain_name" {
        description = "CloudFront Domain"
        value       = aws_cloudfront_distribution.s3_distribution.domain_name
    }

#endregion