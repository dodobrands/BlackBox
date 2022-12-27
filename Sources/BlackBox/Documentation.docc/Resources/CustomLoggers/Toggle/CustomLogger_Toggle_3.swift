class AlertLogger: BBLoggerProtocol {
    let alertService: AlertService
    let levels: [BBLogLevel]
    let isEnabled: () -> Bool
    
    init(alertService: AlertService,
         levels: [BBLogLevel],
         isEnabled: @escaping () -> Bool) {
        self.alertService = alertService
        self.levels = levels
        self.isEnabled = isEnabled
    }
    
    func log(_ event: BlackBox.GenericEvent) {
        guard isEnabled() else { return }
        guard levels.contains(event.level) else { return }
        alertService.showMessage(event.message)
    }
    
    func log(_ event: BlackBox.ErrorEvent) {
        guard isEnabled() else { return }
        guard levels.contains(event.level) else { return }
        alertService.showError(event.message)
    }
    
    func logStart(_ event: BlackBox.StartEvent) {
        // ignore
    }
    
    func logEnd(_ event: BlackBox.EndEvent) {
        guard isEnabled() else { return }
        guard levels.contains(event.level) else { return }
        alertService.showMessage(event.message)
    }
}
