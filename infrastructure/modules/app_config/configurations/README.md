# Important Notice About App Configurations

If any app configurations are modified manually e.g. new flag version, terraform will not be able to delete the App Config instances as it does not own the Feature Flag versions.
Therefore we have three instances of the configuration per deployment.

{date}-dev.json  (sandboxes, dev and test)
{date}-pre-prod.json
{date}-prod.json

It is recomended that all feature flags are enabled for the dev version to reduce manual app config actions.
The prod version should be set to what we expect our prod instances to represent.
