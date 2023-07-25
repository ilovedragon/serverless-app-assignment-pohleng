#Reference URL : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification#add-notification-configuration-to-sqs-queue

#Create the queuce(without the policy)
resource "aws_sqs_queue" "queue" {
  name   = "s3-event-notification-queue-for-pohleng" #change name here
#  policy = data.aws_iam_policy_document.queue.json
}

#Create the policy, and the resource would reference the created queue.
data "aws_iam_policy_document" "queue" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions   = ["sqs:SendMessage"]
#    resources = ["arn:aws:sqs:*:*:s3-event-notification-queue-for-pohleng"] #change name here
     resources = [aws_sqs_queue.queue.arn] #change name here
    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_s3_bucket.bucket.arn]
    }
  }
}

#Attached the policy to the queue
resource "aws_sqs_queue_policy" "queue_policy" {
  queue_url = aws_sqs_queue.queue.id
  policy    = data.aws_iam_policy_document.queue.json
}

resource "aws_s3_bucket" "bucket" {
  bucket = "serverless-app-assignment-pohleng-bucket" #change name here
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.bucket.id

  queue {
    queue_arn     = aws_sqs_queue.queue.arn
    events        = ["s3:ObjectCreated:*", "s3:ObjectRemoved:*"] #change events here 
  }
}