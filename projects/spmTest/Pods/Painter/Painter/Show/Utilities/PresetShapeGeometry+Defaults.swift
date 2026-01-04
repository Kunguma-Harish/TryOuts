//
//  PresetShapeGeometry+Defaults.swift
//  Painter
//
//  Created by Sarath Kumar G on 15/11/17.
//  Copyright © 2018 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation
import GraphikosAppleAssets
import Proto

// NOTE: 'BundleIdentifier' is a dummy class created to access 'Preset.txt' through the Bundle object
private class BundleIdentifier: NSObject {}

extension GeometryField.PresetShapeGeometry {
	var presetDefaults: PresetShape {
		let presetName = String(describing: self).lowercased()
		return GeometryField.PresetShapeGeometry.defaults[presetName] ?? PresetShape()
	}
}

private extension GeometryField.PresetShapeGeometry {
	static var defaults: [String: PresetShape] = {
		guard
			let presetsURL = Bundle.getBundle(for: .painterResources).url(
				forResource: "Preset",
				withExtension: "txt"),
			let presetsJSON = try? String(contentsOf: presetsURL),
			let defaultvalues = try? DefaultPresetShapeValue(
				jsonString: #"{"presets":"# + presetsJSON + "}"
			)
		else {
			assertionFailure("Can't read 'Preset.txt' in \(#function)")
			return [:]
		}
		var renamedvalues: [String: PresetShape] = [:]
		for (key, value) in defaultvalues.presets {
			let mkey = key.replacingOccurrences(of: "_", with: "").lowercased()
			renamedvalues[mkey] = value
		}
		return renamedvalues
	}()
}
