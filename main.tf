
module "IAM" {

    source = "./modules/Iam"
  
}

module "Lambda" {

    depends_on = [module.IAM]
    source = "./modules/EventBridge"
    LambdaName = "tyTestLambda"
    EventRuleName = "testTrigger"
    LambdaIAM = module.IAM.LambdaIamARN
}