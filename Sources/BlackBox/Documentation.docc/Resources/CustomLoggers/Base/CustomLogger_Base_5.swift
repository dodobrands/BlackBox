let AlertLogger = AlertLogger()
let defaultLoggers = BlackBox.defaultLoggers
let loggers = defaultLoggers + [AlertLogger]

BlackBox.instance = BlackBox(loggers: loggers)
