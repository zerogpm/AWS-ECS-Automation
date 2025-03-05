# modules/security/main.tf

module "loadbalancer_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name        = "loadbalancer-sg"
  description = "Security Group with HTTP open for entire Internet (IPv4 CIDR), egress ports are all world open"
  vpc_id      = var.vpc_id
  # Ingress Rules & CIDR Blocks
  ingress_rules       = ["http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  # Egress Rule - all-all open
  egress_rules = ["all-all"]
  tags         = var.tags

# Another way to define mutiple points which base on SGs
#   ingress_with_source_security_group_id = [
#     {
#       from_port                = 80
#       to_port                  = 80
#       protocol                 = "tcp"
#       description              = "Allow HTTP from ALB"
#       source_security_group_id = module.alb_sg.security_group_id
#     },
#     {
#       from_port                = 81
#       to_port                  = 81
#       protocol                 = "tcp"
#       description              = "Allow Port 81 from ALB"
#       source_security_group_id = module.alb_sg.security_group_id
#     }
#   ]
}