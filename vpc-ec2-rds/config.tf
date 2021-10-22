# ------------------------------------------------------------#
#  Terraform Remote State
# ------------------------------------------------------------#
terraform {
  backend "s3" {
    bucket  = "terraform-state"
    key     = "terraform-state/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "hog******"
  }
}
