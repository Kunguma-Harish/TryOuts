//
//  PainterDebugger.swift
//  Painter
//
//  Created by Hariharan S on 27/05/24.
//  Copyright © 2024 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation

enum Debugger {
	struct LogFilter: OptionSet {
		let rawValue: Int
		static let debug = Self(rawValue: 1 << 0)
		static let `deinit` = Self(rawValue: 1 << 1)

#if DEBUG
		static let `default`: [Self] = [.debug]
		static let all: [Self] = `default` + [.deinit]
#else
		static let `default`: [Self] = []
		static let all: [Self] = []
#endif
	}

	static var logFilter = LogFilter.default

	static func debug(_ any: Any) {
		if self.logFilter.contains(.debug) {
			print("🔵 \(any)")
		}
	}

	static func deInit(_ any: Any) {
		if self.logFilter.contains(.deinit) {
			print("\(any) Deinitialised")
		}
	}
}
