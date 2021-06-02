resource "aws_iam_role" "fargate_task_execution" {
  name               = "role-fargate-task-execution"
  assume_role_policy = file("./roles/fargate_task_assume_role.json")
}

resource "aws_iam_role" "fargate_task_role" {
  name               = "role-fargate-task-role"
  assume_role_policy = file("./roles/fargate_task_assume_role.json")
}

resource "aws_iam_role_policy" "fargate_task_execution" {
  name   = "execution-policy"
  role   = aws_iam_role.fargate_task_execution.name
  policy = file("./roles/fargate_task_execution_policy.json")
}

resource "aws_iam_role_policy" "fargate_task_role" {
  name   = "role-policy"
  role   = aws_iam_role.fargate_task_role.name
  policy = file("./roles/fargate_task_role_policy.json")
}