//
//  ExampleService.swift
//  
//
//  Created by Aleksey Berezka on 14.10.2022.
//

import Foundation
import BlackBox

class ExampleService {
    func doSomeWork() {
        BlackBox.log("Doing some work")
    }
    
    func logSomeError() {
        BlackBox.log(ExampleError.taskFailed)
    }
    
    func finishLog(_ log: BlackBox.StartEvent) {
        BlackBox.logEnd(log)
    }
}

enum ExampleError: Error {
    case taskFailed
}
