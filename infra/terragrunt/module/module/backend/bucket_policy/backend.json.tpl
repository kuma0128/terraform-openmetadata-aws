{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": [
                "${s3_bucket_arn}",
                "${s3_bucket_arn}/*"
            ],
            "Condition": {
                "StringNotLike": {
                    "aws:userid": ${jsonencode(allowed_aws_roles)}
                },
                "StringNotEquals": {
                    "aws:SourceVpce": ${jsonencode(allowed_vpce_ids)}
                },
                "NotIpAddress": {
                    "aws:SourceIp": ${jsonencode(allowed_ips)}
                }
            }
        },
        {
            "Sid": "EnforceTLSv12orHigher",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": [
                "${s3_bucket_arn}",
                "${s3_bucket_arn}/*"
            ],
            "Condition": {
                "NumericLessThan": {
                    "s3:TlsVersion": "1.2"
                }
            }
        },
        {
            "Sid": "AllowSSLRequestsOnly",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": [
                "${s3_bucket_arn}",
                "${s3_bucket_arn}/*"
            ],
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        }
    ]
}