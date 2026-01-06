data "aws_iam_policy_document" "reporting_sfn_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "reporting_sfn_role" {
  name               = "${terraform.workspace}_reporting_sfn_role"
  assume_role_policy = data.aws_iam_policy_document.reporting_sfn_assume.json
}

data "aws_iam_policy_document" "reporting_sfn_permissions" {
  statement {
    sid     = "InvokeReportingLambdas"
    effect  = "Allow"
    actions = ["lambda:InvokeFunction"]
    resources = [
      module.report-orchestration-lambda.lambda_arn,
      module.report-distribution-lambda.lambda_arn,
    ]
  }
}

resource "aws_iam_role_policy" "reporting_sfn_policy" {
  name   = "${terraform.workspace}_reporting_sfn_policy"
  role   = aws_iam_role.reporting_sfn_role.id
  policy = data.aws_iam_policy_document.reporting_sfn_permissions.json
}

resource "aws_sfn_state_machine" "reporting_daily_reports" {
  name     = "${terraform.workspace}_reporting_daily_reports"
  role_arn = aws_iam_role.reporting_sfn_role.arn

  definition = jsonencode({
    StartAt = "Generate and Upload Reports",
    States = {
      "Generate and Upload Reports" = {
        Type     = "Task",
        Resource = "arn:aws:states:::lambda:invoke",
        Parameters = {
          FunctionName = module.report-orchestration-lambda.lambda_arn,
          Payload      = {}
        },
        ResultSelector = {
          "report_date.$" = "$.Payload.report_date",
          "bucket.$"      = "$.Payload.bucket",
          "prefix.$"      = "$.Payload.prefix",
          "keys.$"        = "$.Payload.keys"
        },
        ResultPath = "$",
        Next       = "Process Reports (Map)"
      },

      "Process Reports (Map)" = {
        Type           = "Map",
        ItemsPath      = "$.keys",
        MaxConcurrency = 25,

        ItemSelector = {
          "bucket.$" = "$.bucket",
          "key.$"    = "$$.Map.Item.Value"
        },

        ItemProcessor = {
          ProcessorConfig = {
            Mode = "INLINE"
          },
          StartAt = "Distribute One Report",
          States = {
            "Distribute One Report" = {
              Type     = "Task",
              Resource = "arn:aws:states:::lambda:invoke",
              Parameters = {
                FunctionName = module.report-distribution-lambda.lambda_arn,
                Payload = {
                  "action"   = "process_one",
                  "bucket.$" = "$.bucket",
                  "key.$"    = "$.key"
                }
              },
              Retry = [
                {
                  ErrorEquals     = ["States.ALL"],
                  IntervalSeconds = 2,
                  MaxAttempts     = 3,
                  BackoffRate     = 2.0
                }
              ],
              End = true
            }
          }
        },
        End = true
      }
    }
  })
}
