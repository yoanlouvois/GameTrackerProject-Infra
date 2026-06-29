data "aws_caller_identity" "current" {}

####################################
# EC2 Assume Role Policy
####################################

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

####################################
# Front EC2 Role
####################################

resource "aws_iam_role" "front_ec2" {
  name               = "${var.project_name}-${var.environment}-front-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

data "aws_iam_policy_document" "front_ec2_policy" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]

    resources = [var.front_repository_arn]
  }
}

resource "aws_iam_policy" "front_ec2" {
  name   = "${var.project_name}-${var.environment}-front-ec2-policy"
  policy = data.aws_iam_policy_document.front_ec2_policy.json
}

resource "aws_iam_role_policy_attachment" "front_ec2" {
  role       = aws_iam_role.front_ec2.name
  policy_arn = aws_iam_policy.front_ec2.arn
}

resource "aws_iam_instance_profile" "front_ec2" {
  name = "${var.project_name}-${var.environment}-front-instance-profile"
  role = aws_iam_role.front_ec2.name
}

####################################
# Back EC2 Role
####################################

resource "aws_iam_role" "back_ec2" {
  name               = "${var.project_name}-${var.environment}-back-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

data "aws_iam_policy_document" "back_ec2_policy" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]

    resources = [var.back_repository_arn]
  }

  statement {
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath"
    ]

    resources = [
      "arn:aws:ssm:*:${data.aws_caller_identity.current.account_id}:parameter/${var.project_name}/${var.environment}/*"
    ]
  }

  statement {
    actions = [
      "secretsmanager:GetSecretValue"
    ]

    resources = [var.backend_secret_arn]
  }
}

resource "aws_iam_policy" "back_ec2" {
  name   = "${var.project_name}-${var.environment}-back-ec2-policy"
  policy = data.aws_iam_policy_document.back_ec2_policy.json
}

resource "aws_iam_role_policy_attachment" "back_ec2" {
  role       = aws_iam_role.back_ec2.name
  policy_arn = aws_iam_policy.back_ec2.arn
}

resource "aws_iam_instance_profile" "back_ec2" {
  name = "${var.project_name}-${var.environment}-back-instance-profile"
  role = aws_iam_role.back_ec2.name
}

####################################
# MySQL EC2 Role
####################################

resource "aws_iam_role" "mysql_ec2" {
  name               = "${var.project_name}-${var.environment}-mysql-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

data "aws_iam_policy_document" "mysql_ec2_policy" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue"
    ]

    resources = [var.mysql_secret_arn]
  }

  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket"
    ]

    resources = [
      var.mysql_backups_bucket_arn,
      "${var.mysql_backups_bucket_arn}/*"
    ]
  }
}

resource "aws_iam_policy" "mysql_ec2" {
  name   = "${var.project_name}-${var.environment}-mysql-ec2-policy"
  policy = data.aws_iam_policy_document.mysql_ec2_policy.json
}

resource "aws_iam_role_policy_attachment" "mysql_ec2" {
  role       = aws_iam_role.mysql_ec2.name
  policy_arn = aws_iam_policy.mysql_ec2.arn
}

resource "aws_iam_instance_profile" "mysql_ec2" {
  name = "${var.project_name}-${var.environment}-mysql-instance-profile"
  role = aws_iam_role.mysql_ec2.name
}

####################################
# GitHub Actions OIDC
####################################

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]
}

data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        for repo in var.github_repositories : "repo:${repo}:*"
      ]
    }
  }
}

resource "aws_iam_role" "github_actions" {
  name               = "${var.project_name}-${var.environment}-github-actions-role"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json
}

data "aws_iam_policy_document" "github_actions_policy" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
      "ecr:DescribeRepositories",
      "ecr:BatchGetImage"
    ]

    resources = [
      var.front_repository_arn,
      var.back_repository_arn
    ]
  }
}

resource "aws_iam_policy" "github_actions" {
  name   = "${var.project_name}-${var.environment}-github-actions-policy"
  policy = data.aws_iam_policy_document.github_actions_policy.json
}

resource "aws_iam_role_policy_attachment" "github_actions" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions.arn
}