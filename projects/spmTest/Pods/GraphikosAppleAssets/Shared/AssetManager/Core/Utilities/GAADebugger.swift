//
//  GAADebugger.swift
//  GraphikosAppleAssets
//
//  Created by Sarath Kumar G on 11/01/23.
//  Copyright © 2023 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation

enum Debugger {
    struct LogFilter: OptionSet {
        let rawValue: Int

        static let debug = Self(rawValue: 1 << 0)
        static let warning = Self(rawValue: 1 << 1)
        static let `deinit` = Self(rawValue: 1 << 2)

        #if DEBUG
            static let `default`: [Self] = [.debug, .warning]
            static let all: [Self] = `default` + [.deinit]
        #else
            static let `default`: [Self] = []
            static let all: [Self] = []
        #endif
    }

    static var logFilter = LogFilter.default

    static func debug(_ message: Any) {
        if self.logFilter.contains(.debug) {
            debugPrint("Debug:- \(message)")
        }
    }

    static func warn(_ message: Any) {
        if self.logFilter.contains(.deinit) {
            print("Warn:- \(message)")
        }
    }

    static func deInit(_ className: AnyClass) {
        if self.logFilter.contains(.deinit) {
            print("\(className) Deinitialized")
        }
    }
}
