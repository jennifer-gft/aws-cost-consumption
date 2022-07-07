
module "IAM" {

    source = "./modules/Iam"
  
}

module "Lambda" {

    depends_on = [module.IAM]
    source = "./modules/EventBridge"
    LambdaName = ""
    LambdaIAM = module.IAM.LambdaIamARN
}