//
//  Logger.swift
//  TruckMaster
//
//  Created by AuthentiCode on 03/06/26.
//

internal import Foundation

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
        print("│ REQUEST: \(method) \(url)")
        if let body = body {
            printBody(body)
        }
        print("└─────────────────────────────────────────")
        #endif
    }

    static func logResponse(statusCode: Int, body: String?) {
        #if DEBUG
        print("┌─────────────────────────────────────────")
        print("│ RESPONSE STATUS: \(statusCode)")
        if let body = body {
            printBody(body)
        }
        print("└─────────────────────────────────────────")
        print("")
        #endif
    }

    static func logError(_ error: Error) {
        #if DEBUG
        print("┌─────────────────────────────────────────")
        print("│ ERROR")
        print("│ \(error.localizedDescription)")
        print("└─────────────────────────────────────────")
        print("")
        #endif
    }

    // MARK: - Socket logging

    static func logSocketEmit(event: String, payload: [String: Any]) {
        #if DEBUG
        print("")
        print("┌─────────────────────────────────────────")
        print("│ SOCKET EMIT: \(event)")
        printBody(jsonString(from: payload))
        print("└─────────────────────────────────────────")
        #endif
    }

    static func logSocketResponse(event: String, payload: Any) {
        #if DEBUG
        print("┌─────────────────────────────────────────")
        print("│ SOCKET RESPONSE: \(event)")
        printBody(jsonString(from: payload))
        print("└─────────────────────────────────────────")
        print("")
        #endif
    }

    static func logSocketEvent(name: String, items: [Any]) {
        #if DEBUG
        print("[ SOCKET   ] \(name) — \(items)")
        #endif
    }

    // MARK: - Body formatting

    private static func printBody(_ body: String) {
        #if DEBUG
        print("│ BODY:")
        for line in prettyPrinted(body).split(separator: "\n", omittingEmptySubsequences: false) {
            print("│   \(line)")
        }
        #endif
    }

    private static func prettyPrinted(_ raw: String) -> String {
        guard let data = raw.data(using: .utf8),
              let object = try? JSONSerialization.jsonObject(with: data),
              let prettyData = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .sortedKeys]),
              let prettyString = String(data: prettyData, encoding: .utf8)
        else {
            return raw
        }
        return prettyString
    }

    private static func jsonString(from object: Any) -> String {
        guard JSONSerialization.isValidJSONObject(object),
              let data = try? JSONSerialization.data(withJSONObject: object),
              let string = String(data: data, encoding: .utf8)
        else {
            return "\(object)"
        }
        return string
    }
}

// Usage
// Logger.log("User Logged In")
// Logger.log("User Logged In", category: .info)
// Logger.logRequest(url: "...", method: "POST", body: "...")
// Logger.logResponse(statusCode: 200, body: "...")
// Logger.logError(error)
// Logger.logSocketEmit(event: "join_room", payload: [...])
// Logger.logSocketResponse(event: "join_room", payload: [...])
