module "s3" {
  source = "./modules/s3"
  bucket_name = var.bucket_name
  files_bucket = var.files_bucket
}

module "iam" {
  source = "./modules/iam"
  bucket_arn = module.s3.bucket_arn
}


module "ec2" {
    source = "./modules/ec2"
    bucket_name = var.bucket_name
    var_instance_profile = module.iam.ec2_s3_instance_profile_name
}

