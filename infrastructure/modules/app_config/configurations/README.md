Important!

If any app configurations are modified manually e.g. new flag version, terraform will not be able to delete the App Config instances as it does not own the Feature Flag versions.
Therefore we have two instances of the configuration per deployment. 

{date}.json
{date}-dev.json

It is recomended that all feature flags are enabled for the dev version to reduce manual app config actions. 
The non dev version should be set to what we expect our prod instances to represent.  