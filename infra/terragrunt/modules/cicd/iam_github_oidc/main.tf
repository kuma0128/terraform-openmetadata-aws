resource "aws_iam_openid_connect_provider" "this" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = data.tls_certificate.github_actions.certificates[*].sha1_fingerprint
}

resource "aws_iam_role" "this" {
  name = "${var.name_prefix}-iamrole-${var.region_short_name}-oidc"
  assume_role_policy = templatefile(
    "${path.module}/iam_assume_policy/oidc.json.tpl",
    {
      ocid_provider_arn = aws_iam_openid_connect_provider.this.arn
      repo_full_name    = var.repo_full_name
    }
  )
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess" # Be sure to minimize permissions!
}
