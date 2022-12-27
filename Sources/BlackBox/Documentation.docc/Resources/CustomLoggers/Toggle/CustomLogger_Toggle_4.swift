let remoteFlagName = "AlertLoggerEnabled"

var isAlertLoggerEnabled: () -> Bool = { remoteFeatureFlagProvider.isEnabled(remoteFlagName) }
