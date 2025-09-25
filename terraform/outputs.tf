output "eks_cluster_name" {
  value = aws_eks_cluster.main.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "eks_cluster_certificate_authority" {
  value = aws_eks_cluster.main.certificate_authority[0].data
}

output "node_group_instance_type" {
  value = aws_eks_node_group.main.instance_types
}

output "node_group_desired_capacity" {
  value = aws_eks_node_group.main.scaling_config[0].desired_size
}

output "bedrock_dev_user_access_key_id" {
  value     = aws_iam_access_key.developer.id
  sensitive = true
}

output "bedrock_dev_user_secret_access_key" {
  value     = aws_iam_access_key.developer.secret
  sensitive = true
}

output "bedrock_dev_user_arn" {
  value = aws_iam_user.developer.arn
}
