resource "aws_iam_role" "eks" {
  name = "eks-instance-role"
  assume_role_policy = templatefile("./policies/eks_role_assume_policy.tpl", {})
}

/*resource "aws_iam_role_policy" "eks_ecr_role" {
  name = "${aws_iam_role.eks.name}-policy"
  role = aws_iam_role.eks.id
  policy = templatefile("./policies/node_instance_role_policy.tpl", {})
}*/

resource "aws_iam_policy" "eks_ecr_policy" {
  name = "${aws_iam_role.eks.name}-policy"
  description = "EKS all policy"

  policy = templatefile("./policies/node_instance_role_policy.tpl", {
    aws_region = var.region,
    account_id = var.account_id
  })
}

resource "aws_iam_role_policy_attachment" "eks-attach" {
  role       = aws_iam_role.eks.name
  policy_arn = aws_iam_policy.eks_ecr_policy.arn
}

// need to attach to main rule (aws eks update-kubeconfig --name cluster --region ap-southeast-1)
resource "aws_iam_policy" "aws_load_balancer_controller_policy" {
  name = "aws-load-balancer-controller-policy"
  description = "aws load balancer controller policy (managed by terraform)"
  policy = templatefile("./policies/aws_load_balancer_controller_policy.tpl", {})
}