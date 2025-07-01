//
//  ByeBooLogger.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 6/25/25.
//

import OSLog

extension OSLog {
    static let subsystem = Bundle.main.bundleIdentifier!
    static let network = OSLog(subsystem: subsystem, category: "Network")
    static let lifeCycle = OSLog(subsystem: subsystem, category: "LifeCycle")
    static let debug = OSLog(subsystem: subsystem, category: "Debug")
    static let data = OSLog(subsystem: subsystem, category: "Data")
    static let error = OSLog(subsystem: subsystem, category: "Error")
}

enum LogLevel {
    
    /// - network: 네트워크 정보
    /// - lifecycle: 뷰컨 생명주기
    /// - debug: 디버깅
    /// - data: 서버에서 받아온 데이터
    /// - error: 오류
    
    case network
    case lifeCycle
    case debug
    case data
    case error(error: Error)
    
    var category: String {
        switch self {
        case .network:
            "Network"
        case .lifeCycle:
            "LifeCycle"
        case .debug:
            "Debug"
        case .data:
            "Data"
        case .error:
            "Error"
        }
    }
    
    var osLog: OSLog {
        switch self {
        case .network:
                .network
        case .lifeCycle:
                .lifeCycle
        case .debug:
                .debug
        case .data:
                .data
        case .error:
                .error
        }
    }
    
    var osLogType: OSLogType {
        switch self {
        case .network, .lifeCycle, .data:
                .default
        case .debug:
                .debug
        case .error:
                .error
        }
    }
}

struct ByeBooLogger {
    private static func log(
        level: LogLevel,
        message: Any,
        file: String,
        function: String
    ) {
        #if DEBUG
        let logger = Logger(subsystem: OSLog.subsystem, category: level.category)
        let logMessage = "\(message)"
        let fileName = (file as NSString).lastPathComponent
        
        switch level {
        case .network:
            logger.log("[🛜 Network] [\(fileName) -> \(function)]: \(logMessage)")
        case .lifeCycle:
            logger.log("[🔄 LifeCycle] [\(fileName) -> \(function)]: \(logMessage)")
        case .debug:
            logger.debug("[🐛 Debug] [\(fileName) -> \(function)]: \(logMessage)")
        case .data:
            logger.info("[📊 Data] [\(fileName) -> \(function)]: \(logMessage)")
        case .error(let error):
            logger.error("[❌ Error] [\(fileName) -> \(function)]: \(error.localizedDescription)")
        }
        #endif
    }
    
    static func network(
        _ message: Any,
        file: String = #file,
        function: String = #function
    ) {
        log(level: .network, message: message, file: file, function: function)
    }
    
    static func lifeCycle(
        _ message: Any,
        file: String = #file,
        function: String = #function
    ) {
        log(level: .lifeCycle, message: message, file: file, function: function)
    }
    
    static func debug(
        _ message: Any,
        file: String = #file,
        function: String = #function
    ) {
        log(level: .debug, message: message, file: file, function: function)
    }
    
    static func data(
        _ message: Any,
        file: String = #file,
        function: String = #function
    ) {
        log(level: .data, message: message, file: file, function: function)
    }
    
    static func error(
        _ error: Error,
        file: String = #file,
        function: String = #function
    ) {
        log(level: .error(error: error), message: "", file: file, function: function)
    }
}
