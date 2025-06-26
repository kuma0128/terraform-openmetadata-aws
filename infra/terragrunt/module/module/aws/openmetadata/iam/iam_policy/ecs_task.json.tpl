{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Effect":"Allow",
         "Action":[
            "s3:GetObject"
         ],
         "Resource":[
            "${s3_bucket_arn}/*"
         ],
         "Condition":{
            "ArnLike":{
            "aws:SourceArn":"arn:aws:ecs:${region}:${account_id}:*"
            },
            "StringEquals":{
               "aws:SourceAccount": "${account_id}"
            }
         }
      },
      {
          "Effect": "Allow",
          "Action": [
              "ssmmessages:CreateControlChannel",
              "ssmmessages:CreateDataChannel",
              "ssmmessages:OpenControlChannel",
              "ssmmessages:OpenDataChannel"
          ],
          "Resource": "*"
      }
   ]
}