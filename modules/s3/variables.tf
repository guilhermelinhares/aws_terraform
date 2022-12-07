#region - S3

variable "acl" {
  description = "Types of ACL: private || public-read || public-read-write || aws-exec-read	 || authenticated-read	|| bucket-owner-read || bucket-owner-full-control || log-delivery-write	"
  default     = "public-read"
}

#endregion


#region - Cloudfront

  variable "price_class_type" {
    description = "Price class types -> PriceClass_All || PriceClass_200 || PriceClass_100"
    default     = "PriceClass_All" 
  }

  variable "protocol_polocity_method" {
    description  = "Method of protocols -> allow-all || https-only || redirect-to-https"
    default      = "allow-all"
  }

  variable "restriction_type" {
    description = "Types -> none || whitelist || blacklist"
    default     = "none"    
  }

#endregion