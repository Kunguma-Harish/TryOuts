//
//  PatternFill+Defaults.swift
//  Painter
//
//  Created by Meenatchi Ramanathan on 08/07/20.
//  Copyright © 2020 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation
import GraphikosAppleAssets
import Proto

extension PatternFill {
	static func getDefaultPatternFill(for patternType: String) -> PatternFill {
		if PatternPresets.patternPresetDefaults == nil {
			PatternPresets.patternPresetDefaults = patternPresetDefaults
		}

		guard let patternPresets = PatternPresets.patternPresetDefaults else {
			assertionFailure("Pattern Preset Defaults data is empty in \(#function)")
			return PatternFill()
		}
		let patternName = String(describing: patternType)
		if let patternFill = patternPresets.first(
			where: { $0.key.elementsEqual(patternName) }
		) {
			return patternFill.value
		}
		return PatternFill()
	}
}

private extension PatternFill {
	enum PatternPresets {
		static var patternPresetDefaults: [String: PatternFill]?
	}

	/// Default values of all Pattern Preset Shapes from 'PatternPresets.json'
	static var patternPresetDefaults: [String: PatternFill] {
		var patternPresets: [String: PatternFill] = [:]
		guard
			let path = Bundle.getBundle(for: .painterResources).url(
				forResource: "PatternPresets",
				withExtension: "json")
		else {
			assertionFailure("Can't read 'PatternPresets.json' in \(#function)")
			return patternPresets
		}
		do {
			let content = try Data(contentsOf: path)
			let json = try JSONSerialization.jsonObject(with: content, options: .allowFragments)

			if let dictionary = json as? [String: Any] {
				for (key, value) in dictionary {
					let data = try JSONSerialization.data(withJSONObject: value, options: [])
					if let jsonString = String(data: data, encoding: .utf8) {
						let patternFill = try? PatternFill(jsonString: jsonString)
						patternPresets[key] = patternFill
					}
				}
				return patternPresets
			}
		} catch {
			assertionFailure("Can't construct Pattern Preset objects - \(error)")
		}
		return patternPresets
	}
}
