# ✅ modules/codedeploy/backend/main.tf

resource "aws_codedeploy_app" "this" {
  name             = var.app_name
  compute_platform = "Server"
}

# ✅ 기존 IAM Role 가져오기 (생성 안 함!)
data "aws_iam_role" "codedeploy_service_role" {
  name = var.service_role_name  # ← terraform.tfvars 에 있는 "CodeDeployRole" 사용
}


resource "aws_codedeploy_deployment_group" "this" {
  app_name              = aws_codedeploy_app.this.name
  deployment_group_name = var.deployment_group_name
  service_role_arn      = data.aws_iam_role.codedeploy_service_role.arn

  deployment_style {
    deployment_type   = "IN_PLACE"
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
  }

  ec2_tag_filter {
    key   = var.ec2_tag_key
    type  = "KEY_AND_VALUE"
    value = var.ec2_tag_value
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}
