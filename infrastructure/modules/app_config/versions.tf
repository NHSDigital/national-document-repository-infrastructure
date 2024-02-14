locals {
  config_path = "${path.module}/configurations/"
}

resource "aws_appconfig_hosted_configuration_version" "ndr-app-config-profile-version-v1-0" {
  application_id           = aws_appconfig_application.ndr-app-config-application.id
  configuration_profile_id = aws_appconfig_configuration_profile.ndr-app-config-profile.configuration_profile_id
  description              = "version-${sha256(file("${local.config_path}/v1.0.json"))}"
  content                  = file("${local.config_path}/v1.0.json")
  content_type             = "application/json"

  depends_on = [
    aws_appconfig_configuration_profile.ndr-app-config-profile
  ]
}

resource "aws_appconfig_hosted_configuration_version" "ndr-app-config-profile-version-v1-1" {
  application_id           = aws_appconfig_application.ndr-app-config-application.id
  configuration_profile_id = aws_appconfig_configuration_profile.ndr-app-config-profile.configuration_profile_id
  description              = "version-${sha256(file("${local.config_path}/v1.1.json"))}"
  content                  = file("${local.config_path}/v1.1.json")
  content_type             = "application/json"

  depends_on = [
    aws_appconfig_configuration_profile.ndr-app-config-profile
  ]
}