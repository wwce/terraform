provider "aws" {
    region                    = var.AWS_REGION
    #shared_credentials_file  = pathexpand(var.AWS_SHARED_CREDS)
    #profile                  = pathexpand(var.AWS_SHARED_CREDS_PROFILE)
}