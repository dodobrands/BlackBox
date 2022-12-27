class AlertLogger: BBLoggerProtocol {
    let alertService: AlertService
    let levels: [BBLogLevel]
    
    init(alertService: AlertService,
         levels: [BBLogLevel]) {
        self.alertService = alertService
        self.levels = levels
    }
    
    func log(_ event: BlackBox.GenericEvent) {
        guard levels.contains(event.level) else { return }
        alertService.showMessage(event.message)
    }
    
    func log(_ event: BlackBox.ErrorEvent) {
        guard levels.contains(event.level) else { return }
        alertService.showError(event.message)
    }
    
    func logStart(_ event: BlackBox.StartEvent) {
        // ignore
    }
    
    func logEnd(_ event: BlackBox.EndEvent) {
        guard levels.contains(event.level) else { return }
        alertService.showMessage(event.message)
    }
}
