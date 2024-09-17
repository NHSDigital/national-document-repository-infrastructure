resource "aws_iam_role" "task_exec" {
  name = "${terraform.workspace}-${var.ecs_cluster_name}-ecs-task"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : [
              "ecs-tasks.amazonaws.com"
            ]
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "ecs_task_exec" {
  role       = aws_iam_role.task_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "s3_access" {
  name = "${terraform.workspace}-${var.ecs_cluster_name}-s3-access-policy"
  role = aws_iam_role.task_exec.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject"
        ],
        Effect   = "Allow",
        Resource = ["arn:aws:s3:::prod-${var.aws_region}-starport-layer-bucket/*"]
      }
    ]
  })
}
