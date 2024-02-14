locals {
  config_path = "${path.module}/configurations/"
}

resource "aws_appconfig_hosted_configuration_version" "ndr-app-config-profile-version-v1" {
  application_id           = aws_appconfig_application.ndr-app-config-application.id
  configuration_profile_id = aws_appconfig_configuration_profile.ndr-app-config-profile.configuration_profile_id
  content                  = file("${local.config_path}/v1.json")
  content_type             = "application/json"
  version_number           = 1

  depends_on = [
    aws_appconfig_configuration_profile.ndr-app-config-profile
  ]
}

resource "aws_appconfig_hosted_configuration_version" "ndr-app-config-profile-version-v2" {
  application_id           = aws_appconfig_application.ndr-app-config-application.id
  configuration_profile_id = aws_appconfig_configuration_profile.ndr-app-config-profile.configuration_profile_id
  content                  = file("${local.config_path}/v2.json")
  content_type             = "application/json"
  version_number           = 2

  depends_on = [
    aws_appconfig_hosted_configuration_version.ndr-app-config-profile-version-v1
  ]
}