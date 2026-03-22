resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [local.backend_alb_sg_id]
  subnets            = local.private_subnet_id

#keeping this as false just to delete with terraform
  enable_deletion_protection = false

 tags = merge (
    {
    Name = "${var.project}-${var.environment}"
  },
  local.common_tags
  )
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.backend.arn
  port              = "80"
  protocol          = "HTTP"
  

  default_action {
       type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}

resource "aws_globalaccelerator_accelerator" "main" {
  name            = "foobar-terraform-accelerator"
  enabled         = true
  ip_address_type = "IPV4"
}

resource "aws_route53_record" "www" {
  zone_id = var.zone_id
  name    = "*.backend-alb-${var.environment}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_alb.backend_alb.dns_name
    zone_id                = aws_alb.backend_alb.zone_id
    evaluate_target_health = true
  }
}
