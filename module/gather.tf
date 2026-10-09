# OIDC Assume Role Policy Document
data "aws_iam_policy_document" "eks_oidc_assume_role_policy" {
  count = var.is-eks-cluster-enabled ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks-oidc[0].url, "https://", "")}:sub"
      values   = ["system:serviceaccount:default:aws-test"]
    }

    principals {
      identifiers = [
        aws_iam_openid_connect_provider.eks-oidc[0].arn
      ]
      type = "Federated"
    }
  }
}
