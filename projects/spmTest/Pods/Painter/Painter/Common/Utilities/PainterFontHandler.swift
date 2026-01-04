//
//  PainterFontHandler.swift
//  Painter
//
//  Created by Sarath Kumar G on 23/01/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import GraphikosAppleAssets
import Proto
import SwiftProtobuf

extension Message {
	var isEmpty: Bool {
		return self.isEqualTo(message: Self())
	}
}

public class PainterFontHandler: NSObject {
	public static let shared = PainterFontHandler()

	private let fontStyleIdWeightMap: [String: PortionField.FontWeight] = [
		"100": .thin,
		"200": .extraLight,
		"300": .light,
		"400": .normal,
		"500": .medium,
		"600": .demiBold,
		"700": .bold,
		"800": .heavy,
		"900": .black
	]

	override private init() {
		super.init()
	}

	deinit {
		Debugger.deInit("\(self.classForCoder) deinitialized")
	}
}

public extension PainterFontHandler {
	/// Font Weight for font name
	///
	/// - Parameter fontName: Postscript name of font
	/// - Returns: Weight of given font as PortionField.FontWeight
	func getFontWeight(forFont fontName: String) -> PortionField.FontWeight {
		let styleId = GraphikosAppleAssets.FontHandler.shared.getStyleId(forFont: fontName).replacingOccurrences(of: "i", with: "")
		return self.fontStyleIdWeightMap[styleId] ?? .normal
	}

	func getStyleId(for fontWeight: PortionField.FontWeight) -> String {
		return fontWeight.styleId
	}

	func getFontID(
		forFamily fontFamily: String,
		withStyle styleId: String,
		using config: PainterConfig? = nil) -> String {
		var fontId = config?.getFontId(forFamily: fontFamily, forStyle: styleId) ?? ""
		if fontId.isEmpty {
			fontId = GraphikosAppleAssets.FontHandler.shared.getDefaultFontId(
				forStyle: styleId
			)
		}
		return fontId
	}
}
