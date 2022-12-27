let remoteFlagName = "AlertLoggerEnabled"

var isAlertLoggerEnabled: () -> Bool = { remoteFeatureFlagProvider.isEnabled(remoteFlagName) }

let logger = AlertLogger(alertService: AlertService(),
                         levels: [.info, .warning, .error],
                         isEnabled: isAlertLoggerEnabled)
