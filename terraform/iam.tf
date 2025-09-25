resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.cluster_name}-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role_policy.json
}

data "aws_iam_policy_document" "eks_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role" "eks_node_role" {
  name = "${var.cluster_name}-node-role"
  assume_role_policy = data.aws_iam_policy_document.eks_node_assume_role_policy.json
}

data "aws_iam_policy_document" "eks_node_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

# Read-only developer user
resource "aws_iam_user" "developer" {
  name = "bedrock-dev-user"
}

resource "aws_iam_access_key" "developer" {
  user = aws_iam_user.developer.name
}

data "aws_iam_policy_document" "developer_readonly" {
  statement {
    sid    = "ReadOnlyAccess"
    effect = "Allow"
    actions = [
      "eks:Describe*",
      "eks:List*",
      "ec2:Describe*",
      "rds:Describe*",
      "dynamodb:ListTables",
      "dynamodb:DescribeTable",
      "elasticache:Describe*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "developer_readonly" {
  name   = "BedrockDevUserReadOnlyPolicy"
  policy = data.aws_iam_policy_document.developer_readonly.json
}

resource "aws_iam_user_policy_attachment" "developer_readonly" {
  user       = aws_iam_user.developer.name
  policy_arn = aws_iam_policy.developer_readonly.arn
}
