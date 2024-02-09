output "app_config_application" {
  value = aws_appconfig_application.ndr-app-config-application.id
}

output "app_config_environment" {
  value = aws_appconfig_environment.ndr-app-config-environment.environment_id
}

output "app_config_configuration_profile" {
  value = aws_appconfig_configuration_profile.ndr-app-config-profile.configuration_profile_id
}