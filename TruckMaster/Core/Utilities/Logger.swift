//
//  Logger.swift
//  TruckMaster
//
//  Created by AuthentiCode on 03/06/26.
//

import Foundation

enum Logger {

    enum Category {
        case request
        case response
        case error
        case info

        var prefix: String {
            switch self {
            case .request:  return "[ REQUEST  ]"
            case .response: return "[ RESPONSE ]"
            case .error:    return "[ ERROR    ]"
            case .info:     return "[ INFO     ]"
            }
        }
    }

    static func log(_ message: String, category: Category = .info) {
        #if DEBUG
        print("\(category.prefix) \(message)")
        #endif
    }

    static func logRequest(url: String, method: String, body: String?) {
        #if DEBUG
        print("")
        print("┌─────────────────────────────────────────")
        print("│ [ REQUEST ]")
        print("│ \(method) \(url)")
        if let body = body {
            print("│ BODY: \(body)")
        }
        print("└─────────────────────────────────────────")
        #endif
    }

    static func logResponse(statusCode: Int, body: String?) {
        #if DEBUG
        print("┌─────────────────────────────────────────")
        print("│ [ RESPONSE ] STATUS: \(statusCode)")
        if let body = body {
            print("│ BODY: \(body)")
        }
        print("└─────────────────────────────────────────")
        print("")
        #endif
    }

    static func logError(_ error: Error) {
        #if DEBUG
        print("┌─────────────────────────────────────────")
        print("│ [ ERROR ]")
        print("│ \(error.localizedDescription)")
        print("└─────────────────────────────────────────")
        print("")
        #endif
    }
}

// Usage
// Logger.log("User Logged In")
// Logger.log("User Logged In", category: .info)
// Logger.logRequest(url: "...", method: "POST", body: "...")
// Logger.logResponse(statusCode: 200, body: "...")
// Logger.logError(error)
