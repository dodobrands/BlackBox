//
//  OSLoggerTests.swift
//  
//
//  Created by Aleksey Berezka on 13.10.2022.
//

import Foundation
import XCTest
@testable import BlackBox
import os

class OSLoggerTests: BlackBoxTestCase {
    var osLogger: OSLoggerMock!
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        createOSLogger(levels: .allCases)
    }
    
    override func tearDownWithError() throws {
        logger = nil
        osLogger = nil
        try super.tearDownWithError()
    }
    
    private func createOSLogger(
        levels: [BBLogLevel], 
        logFormat: BBLogFormat = .fixedLocale
    ) {
        osLogger = .init(levels: levels, logFormat: logFormat)
        BlackBox.instance = .init(loggers: [osLogger])
        
        logger = osLogger
    }
    
    func test_genericEvent_message() {
        BlackBox.log("Hello there")
        
        
        let expectedResult = """

Hello there

[Source]
OSLoggerTests:38
test_genericEvent_message()
"""
        XCTAssertEqual(osLogger.data?.message, expectedResult)
    }
    
    func test_genericEvent_userInfo() {
        BlackBox.log("Hello there", userInfo: ["response": "General Kenobi"])
        
        let expectedResult = """

Hello there

[Source]
OSLoggerTests:53
test_genericEvent_userInfo()

[User Info]
{
  "response" : "General Kenobi"
}
"""
        XCTAssertEqual(osLogger.data?.message, expectedResult)
    }
    
    struct Response {
        let value: String
    }
    func test_genericEvent_userInfo_nonCodable() {
        BlackBox.log("Hello there", userInfo: ["response": Response(value: "General Kenobi")])
        
        let expectedResult = """

Hello there

[Source]
OSLoggerTests:75
test_genericEvent_userInfo_nonCodable()

[User Info]
["response": BlackBoxTests.OSLoggerTests.Response(value: "General Kenobi")]
"""
        XCTAssertEqual(osLogger.data?.message, expectedResult)
    }
    
    func test_genericEvent_invalidLevels() {
        createOSLogger(levels: [.error])

        let logLevels: [BBLogLevel] = [.debug, .info, .warning]
        
        logLevels.forEach { level in
            BlackBox.log("Hello There", level: level)
        }
        
        XCTAssertNil(osLogger.data)
    }
    
    func test_genericEvent_validLevel() {
        createOSLogger(levels: [.error])
        
        BlackBox.log("Hello There", level: .error)
        let expectedResult = """

Hello There

[Source]
OSLoggerTests:106
test_genericEvent_validLevel()
"""
        XCTAssertEqual(osLogger.data?.message, expectedResult)
    }
    
    func test_genericEvent_level_debugMapsToDefault() {
        BlackBox.log("Hello There", level: .debug)
        XCTAssertEqual(osLogger.data?.logType.rawValue, OSLogType.default.rawValue)
    }
    
    func test_genericEvent_level_infoMapsToInfo() {
        BlackBox.log("Hello There", level: .info)
        XCTAssertEqual(osLogger.data?.logType.rawValue, OSLogType.info.rawValue)
    }
    
    func test_genericEvent_level_warningMapsToError() {
        BlackBox.log("Hello There", level: .warning)
        XCTAssertEqual(osLogger.data?.logType.rawValue, OSLogType.error.rawValue)
    }
    
    func test_genericEvent_level_errorMapsToFault() {
        BlackBox.log("Hello There", level: .error)
        XCTAssertEqual(osLogger.data?.logType.rawValue, OSLogType.fault.rawValue)
    }
    
    func test_genericEvent_subsystem() {
        BlackBox.log("Hello There")
        XCTAssertEqual(osLogger.data?.subsystem, "BlackBoxTests")
    }
    
    func test_genericEvent_categoryProvided() {
        BlackBox.log("Hello There", category: "Analytics")
        XCTAssertEqual(osLogger.data?.category, "Analytics")
    }
    
    func test_genericEvent_categoryNotProvided() {
        BlackBox.log("Hello There")
        XCTAssertEqual(osLogger.data?.category, "")
    }
    
    enum Error: Swift.Error {
        case someError
    }
    
    func test_errorEvent() {
        BlackBox.log(Error.someError)
        let expectedResult = """

OSLoggerTests.Error.someError

[Source]
OSLoggerTests:158
test_errorEvent()
"""
        XCTAssertEqual(osLogger.data?.message, expectedResult)
    }
    
    func test_startEvent() {
        let _ = BlackBox.logStart("Process")
        
        let expectedResult = """

Start: Process

[Source]
OSLoggerTests:171
test_startEvent()
"""
        XCTAssertEqual(osLogger.data?.message, expectedResult)
    }
    
    func test_endEvent() {
        let date = Date()
        let startEvent = BlackBox.StartEvent(
            timestamp: date, 
            "Process"
        )
        
        let endEvent = BlackBox.EndEvent(
            timestamp: date.addingTimeInterval(1),
            startEvent: startEvent
        )
        
        BlackBox.logEnd(endEvent) 
        
        let expectedResult = """

End: Process, duration: 1 sec

[Source]
OSLoggerTests:191
test_endEvent()
"""
        XCTAssertEqual(osLogger.data?.message, expectedResult)
    }
    
    func test_endEvent_durationFormat() {
        let formatter = MeasurementFormatter()
        formatter.locale = Locale(identifier: "es_AR")
        formatter.numberFormatter.minimumFractionDigits = 3
        createOSLogger(levels: .allCases, logFormat: BBLogFormat(measurementFormatter: formatter))
        let date = Date()
        let startEvent = BlackBox.StartEvent(
            timestamp: date, 
            "Process"
        )
        
        let endEvent = BlackBox.EndEvent(
            timestamp: date.addingTimeInterval(1),
            startEvent: startEvent
        )
        
        BlackBox.logEnd(endEvent) 
        
        let expectedResult = """

End: Process, duration: 1,000 seg.

[Source]
OSLoggerTests:220
test_endEvent_durationFormat()
"""
        XCTAssertEqual(osLogger.data?.message, expectedResult)
    }
}

class OSLoggerMock: OSLogger {
    var data: LogData?
    override func osLog(_ data: LogData) {
        self.data = data
        super.osLog(data)
    }
}


    // MARK: - BBLogFormat
extension OSLoggerTests {
    func test_whenLogFormatApplied_showingLevelIcon() {
        let customLogFormat = BBLogFormat(userInfoFormatOptions: [], sourceSectionInline: false, showLevelIcon: true)
        createOSLogger(levels: .allCases, logFormat: customLogFormat)

        BlackBox.log("Hello there")

        let expectedResult = """

🛠 Hello there

[Source]
OSLoggerTests:254
test_whenLogFormatApplied_showingLevelIcon()
"""
        XCTAssertEqual(osLogger.data?.message, expectedResult)

    }

    func test_whenLogFormatApplied_outputSourceSectionInline() {
        let customLogFormat = BBLogFormat(userInfoFormatOptions: [], sourceSectionInline: true, showLevelIcon: false)
        createOSLogger(levels: .allCases, logFormat: customLogFormat)

        BlackBox.log("Hello there")

        let expectedResult = """

Hello there

[Source] OSLoggerTests:272 test_whenLogFormatApplied_outputSourceSectionInline()
"""
        XCTAssertEqual(osLogger.data?.message, expectedResult)

    }

    @available(iOS 13.0, tvOS 13.0, watchOS 13.0, *)
    func test_whenLogFormatApplied_userInfoFormatted() {
        let customLogFormat = BBLogFormat(userInfoFormatOptions: [.prettyPrinted, .withoutEscapingSlashes],
                                          sourceSectionInline: false,
                                          showLevelIcon: false)
        createOSLogger(levels: .allCases, logFormat: customLogFormat)

        BlackBox.log("Hello there", userInfo: ["path": "/api/v1/getData"])

        let expectedResult = """

Hello there

[Source]
OSLoggerTests:291
test_whenLogFormatApplied_userInfoFormatted()

[User Info]
{
  \"path\" : \"/api/v1/getData\"
}
"""
        XCTAssertEqual(osLogger.data?.message, expectedResult)

    }
}

extension BBLogFormat {
    static let fixedLocale = BBLogFormat(measurementFormatter: .fixedLocale)
}

extension MeasurementFormatter {
    static let fixedLocale: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.locale = Locale(identifier: "en-GB")
        return formatter
    }()
}
