#region - Create Load Balancer -> Basic configuration + Mapping
    /**
     * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#network-load-balancer
     * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elb
    */
    resource "aws_lb" "load_balancer" {
        name               = var.name_lb
        load_balancer_type = var.lb_type
        internal           = true
        # security_groups    = [aws_security_group.lb_sg.id]

        subnet_mapping {
            subnet_id            = var.public_subnet_id_a
            private_ipv4_address = var.ipv4_public_cidr_a
        }

        subnet_mapping {
            subnet_id            = var.public_subnet_id_b
            private_ipv4_address = var.ipv4_public_cidr_b
        }

        tags = {
            Environment = "lb_dev"
        }
    }
#endregion

#region - Create a Listeners

resource "aws_lb_listener" "listener_http" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "80"
  protocol          = "TCP"

   default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_group_http.arn
  }
}

resource "aws_lb_listener" "listener_https" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "443"
  protocol          = "TCP"

   default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_group_https.arn
  }
}

#endregion

#region - Create targets Groups
    /**
     * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
    */
    resource "aws_lb_target_group" "tg_group_http" {
        name         = var.aws-lb-tg-http
        port         = 80
        protocol     = "TCP"
        vpc_id       = var.vpc_id

        health_check {
          enabled = true  
          protocol   = "HTTP"
          path       =  "/info.php"
        }
    }
    resource "aws_lb_target_group" "tg_group_https" {
        name         = var.aws-lb-tg-https
        port         = 443
        protocol     = "TCP"
        vpc_id       = var.vpc_id

        health_check {
          enabled = true  
          protocol   = "HTTP"
          path       =  "/info.php"
        }
    }
#endregion