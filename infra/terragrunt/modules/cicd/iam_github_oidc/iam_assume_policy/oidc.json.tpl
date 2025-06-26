{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "${ocid_provider_arn}"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals" : {
                    "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
                },
                "StringNotLike" : {
                    "token.actions.githubusercontent.com:sub" : "repo:${repo_full_name}:*"
                }
            }
        }
    ]
}