terraform {
  backend "s3" {
    bucket = "sctp-ce2-tfstate-bkt"
    key    = "serverless-app-assignment-pholeng.tfstate"   #Change the value  
    region = "ap-southeast-1"
  }
}
