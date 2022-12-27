class AlertLogger: BBLoggerProtocol {
    let alertService: AlertService
    
    init(alertService: AlertService) {
        self.alertService = alertService
    }
    
    func log(_ event: BlackBox.GenericEvent) {
        alertService.showMessage(event.message)
    }
    
    func log(_ event: BlackBox.ErrorEvent) {
        alertService.showError(event.message)
    }
    
    func logStart(_ event: BlackBox.StartEvent) {
        // ignore
    }
    
    func logEnd(_ event: BlackBox.EndEvent) {
        alertService.showMessage(event.message)
    }
}
