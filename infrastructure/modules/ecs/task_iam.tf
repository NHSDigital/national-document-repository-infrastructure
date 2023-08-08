resource "aws_iam_role" "task_exec" {
  name = "${terraform.workspace}-ecs-task"
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
  name       = "${terraform.workspace}-task-exec"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
