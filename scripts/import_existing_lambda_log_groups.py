import sys
import subprocess


class TerraformImportLogGroups:
    def __init__(self, workspace: str, environment: str):
        self.workspace = workspace
        self.environment = environment

        tfvars_files = {
            "development": "dev.tfvars",
            "test": "test.tfvars",
            "pre-prod": "preprod.tfvars",
            "prod": "prod.tfvars",
        }

        self.tfvars = tfvars_files[self.environment]

        module_to_log_map = {
            "access-audit-log-group": self._build_log_group_from_lambda_name(
                "AccessAuditLambda"
            ),
            "authoriser-log-group": self._build_log_group_from_lambda_name(
                "AuthoriserLambda"
            ),
            "back-channel-logout-log-group": self._build_log_group_from_lambda_name(
                "BackChannelLogoutHandler"
            ),
            "bulk-upload-log-group": self._build_log_group_from_lambda_name(
                "BulkUploadLambda"
            ),
            "bulk-upload-metadata-log-group": self._build_log_group_from_lambda_name(
                "BulkUploadMetadataLambda"
            ),
            "bulk-upload-report-log-group": self._build_log_group_from_lambda_name(
                "BulkUploadReportLambda"
            ),
            "create-doc-ref-log-group": self._build_log_group_from_lambda_name(
                "CreateDocRefLambda"
            ),
            "create-token-log-group": self._build_log_group_from_lambda_name(
                "TokenRequestHandler"
            ),
            "data-collection-log-group": self._build_log_group_from_lambda_name(
                "DataCollectionLambda"
            ),
            "delete-document-object-log-group": self._build_log_group_from_lambda_name(
                "DeleteDocumentObjectS3"
            ),
            "delete-doc-ref-log-group": self._build_log_group_from_lambda_name(
                "DeleteDocRefLambda"
            ),
            "document-manifest-job-log-group": self._build_log_group_from_lambda_name(
                "DocumentManifestJobLambda"
            ),
            "feature-flags-log-group": self._build_log_group_from_lambda_name(
                "FeatureFlagsLambda"
            ),
            "generate-document-manifest-log-group": self._build_log_group_from_lambda_name(
                "GenerateDocumentManifest"
            ),
            "generate-lloyd-george-stitch-log-group": self._build_log_group_from_lambda_name(
                "GenerateLloydGeorgeStitch"
            ),
            "get-doc-nrl-log-group": self._build_log_group_from_lambda_name(
                "GetDocumentReference"
            ),
            "get-report-by-ods-log-group": self._build_log_group_from_lambda_name(
                "GetReportByODS"
            ),
            "lloyd-george-stitch-log-group": self._build_log_group_from_lambda_name(
                "LloydGeorgeStitchLambda"
            ),
            "login-redirect-log-group": self._build_log_group_from_lambda_name(
                "LoginRedirectHandler"
            ),
            "logout-log-group": self._build_log_group_from_lambda_name("LogoutHandler"),
            "manage-nrl-pointer-log-group": self._build_log_group_from_lambda_name(
                "ManageNrlPointerLambda"
            ),
            "mns-notification-log-group": self._build_log_group_from_lambda_name(
                "MNSNotificationLambda"
            ),
            "nhs-oauth-token-generator-log-group": self._build_log_group_from_lambda_name(
                "NhsOauthTokenGeneratorLambda"
            ),
            "pdf-stitching-log-group": self._build_log_group_from_lambda_name(
                "PdfStitchingLambda"
            ),
            "search-document-references-log-group": self._build_log_group_from_lambda_name(
                "SearchDocumentReferencesLambda"
            ),
            "search-patient-details-log-group": self._build_log_group_from_lambda_name(
                "SearchPatientDetailsLambda"
            ),
            "statistical-report-log-group": self._build_log_group_from_lambda_name(
                "StatisticalReportLambda"
            ),
            "send-feedback-log-group": self._build_log_group_from_lambda_name(
                "SendFeedbackLambda"
            ),
            "update-upload-state-log-group": self._build_log_group_from_lambda_name(
                "UpdateUploadStateLambda"
            ),
            "upload-confirm-result-log-group": self._build_log_group_from_lambda_name(
                "UploadConfirmResultLambda"
            ),
            "virus-scan-result-log-group": self._build_log_group_from_lambda_name(
                "VirusScanResult"
            ),
        }

        self.lambda_log_terraform_modules = module_to_log_map

    def _build_log_group_from_lambda_name(self, lambda_name: str):
        return f"/aws/lambda/{self.workspace}_{lambda_name}"

    def main(self):
        print(
            f"Starting terraform update script for workspace: '{self.workspace}', using the following tfvars file: '{self.tfvars}'"
        )

        for module, log_group in self.lambda_log_terraform_modules.items():
            tf_vars_cmd = f"-var-file={self.tfvars}"
            module_cmd = f"module.{module}.aws_cloudwatch_log_group.ndr"
            log_group_cmd = f"{log_group}"

            try:
                subprocess.run(
                    [
                        "terraform",
                        "import",
                        tf_vars_cmd,
                        module_cmd,
                        log_group_cmd,
                    ],
                    cwd="./infrastructure",
                    check=True,
                )
            except Exception:
                print(
                    f"Failed import for module: '{module}', to the log group: '{log_group}' (The log group may not exist in the AWS env)"
                )


if __name__ == "__main__":
    workspace = sys.argv[1]
    environment = sys.argv[2]
    TerraformImportLogGroups(workspace=workspace, environment=environment).main()
