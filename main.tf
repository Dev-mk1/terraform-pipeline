provider "aws" {
   region = var.region
  }

module "vpc-demo" {
    source = "./vpc"
  availability_zone = var.availability_zone
  env_prefix        = var.env_prefix
  sg                = var.sg
  cidr_blocks       = var.cidr_blocks

 vpc_id             = module.vpc-demo.vpc_id
 alb-sg             = module.vpc-demo.alb-sg
 subnet_id          = module.vpc-demo.subnet_id
 subnet_id_2        = module.vpc-demo.subnet_id_2
  
  

  }
 module "application_lb" { 
  source = "./load-balancer"
load_balancer_type   = var.load_balancer_type
project-name         = var.project-name
target_type          = var.target_type

#lambda-fun           = module.lambda-demo.lambda-fun

alb-sg               = module.vpc-demo.alb-sg
vpc_id               = module.vpc-demo.vpc_id
subnet_id            = module.vpc-demo.subnet_id
subnet_id_2          = module.vpc-demo.subnet_id_2

alb-zone             = module.application_lb.alb-zone
alb-url              = module.application_lb.alb-url
instance-id          = module.ec2.instance-id
 }

################################
/*module "lambda-demo" {
  source = "./lambda-fun"
function_name = var.function_name
runtime       = var.runtime
timeout       = var.timeout
handler       = var.handler
name          = var.name
description   = var.description

lambda-fun    = module.lambda-demo.lambda-fun

}*/
module "ec2" {
  source = "./EC-2"
  ami              = var.ami
  instance_type    = var.instance_type
  key_name         = var.key_name
  source-file-path = var.source-file-path
  destination-path = var.destination-path
  PRIVATE_KEY_PATH = var.PRIVATE_KEY_PATH
  user             = var.user

subnet_id          = module.vpc-demo.subnet_id
alb-sg             = module.vpc-demo.alb-sg

instance-id        = module.ec2.instance-id
}
module "route-53" {
  source = "./route53"
  
  domain-name = var.domain-name
  sub-domain  = var.sub-domain
  record-type = var.record-type
  
  alb-zone    = module.application_lb.alb-zone
  alb-url     = module.application_lb.alb-url
  
}