resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  version  = "1.32"

  vpc_config {
    subnet_ids = [
      aws_subnet.public.id,
      aws_subnet.private.id
    ]
  }

  tags = {
    Name = var.cluster_name
  }

lifecycle {
    ignore_changes = [
      bootstrap_self_managed_addons
    ]
  }
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-nodegroup"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [aws_subnet.private.id]

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }

  instance_types = ["t3.micro"]

  tags = {
    Name = "${var.cluster_name}-nodegroup"
  }

}
