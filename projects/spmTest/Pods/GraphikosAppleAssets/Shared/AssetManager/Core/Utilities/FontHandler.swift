//
//  FontHandler.swift
//  GraphikosAppleAssets
//
//  Created by Sarath Kumar G on 23/01/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

#if os(macOS)
    import AppKit.NSFontManager

    typealias PlatformFont = NSFont
#else
    import UIKit.UIFont

    typealias PlatformFont = UIFont
#endif

public extension PlatformFont {
    var fontFamilyName: String {
        #if os(macOS)
            guard let familyName else {
                assertionFailure("Family name unavailable for \(self) - \(#function)")
                return fontName
            }
            return familyName
        #else
            return self.familyName
        #endif
    }
}

public class FontHandler: NSObject {
    private let styles = [
        "100": ["Thin"],
        "200": ["ExtraLight", "UltraLight"],
        "300": ["Light"],
        "400": ["", "Regular", "Roman", "Inline"],
        "500": ["Medium"],
        "600": ["DemiBold", "SemiBold"],
        "700": ["Bold", "Solid"],
        "800": ["Heavy", "ExtraBold"],
        "900": ["Black"],
        "100i": ["ThinItalic", "ThinOblique"],
        "200i": ["ExtraLightItalic", "UltraLightItalic", "ExtraLightOblique", "UltraLightOblique"],
        "300i": ["LightItalic", "LightOblique"],
        "400i": ["Italic", "Oblique"],
        "500i": ["MediumItalic", "MediumOblique"],
        "600i": ["DemiBoldItalic", "SemiBoldItalic", "DemiBoldOblique", "SemiBoldOblique"],
        "700i": ["BoldItalic", "BoldOblique"],
        "800i": ["HeavyItalic", "HeavyOblique", "ExtraBoldItalic", "ExtraBoldOblique"],
        "900i": ["BlackItalic", "BlackOblique"]
    ]

    private let fontStyleIdWeightLabelMap: [String: String] = [
        "100": "Thin",
        "100i": "Thin Italic",
        "200": "Ultralight",
        "200i": "Ultralight Italic",
        "300": "Light",
        "300i": "Light Italic",
        "400": "Regular",
        "400i": "Italic",
        "500": "Medium",
        "500i": "Medium Italic",
        "600": "Demibold",
        "600i": "Demibold Italic",
        "700": "Bold",
        "700i": "Bold Italic",
        "800": "Heavy",
        "800i": "Heavy Italic",
        "900": "Black",
        "900i": "Black Italic"
    ]

    public static let shared = FontHandler()

    override private init() {
        super.init()
    }

    deinit {
        Debugger.deInit(self.classForCoder)
    }
}

// MARK: - Font Id Getters

public extension FontHandler {
    func isAvailable(fontFamily: String) -> Bool {
        let familyName = self.modifiedFamilyName(forFontFamily: fontFamily)
        #if os(macOS)
            let fontManager = NSFontManager.shared
            return fontManager.availableFontFamilies.contains(familyName)
        #else
            return UIFont.familyNames.contains(familyName)
        #endif
    }

    func isAvailable(fontName: String?, familyName: String) -> Bool {
        if let fontName {
            return self.getFontNames(forFamily: familyName).contains(fontName)
        }
        return false
    }

    func getPostscriptName(forFamily fontFamily: String, withStyle styleId: String) -> String? {
        guard let fontWeights = self.styles[styleId] else {
            return nil
        }
        let fontNames = self.getFontNames(forFamily: fontFamily)
        for fontWeight in fontWeights {
            for fontName in fontNames where self.isValidFontName(fontName, forWeight: fontWeight, withStyleId: styleId) {
                return fontName
            }
        }
        return nil
    }

    func getNullableFontID(forFamily fontFamily: String, withStyle styleId: String) -> String? {
        if let stylesChosen = styles[styleId] {
            let fontNames = self.getFontNames(forFamily: fontFamily)
            for style in stylesChosen {
                for fontName in fontNames where isValidFontName(fontName, forWeight: style, withStyleId: styleId) {
                    return fontName
                }
            }
        }
        return nil
    }

    func modifiedFamilyName(forFontFamily fontFamily: String) -> String {
        if fontFamily.contains("Raleway Dots") {
            return "Raleway Dots "
        }
        return fontFamily
    }

    func getFontNames(forFamily familyName: String) -> [String] {
        var fontNames: [String] = []
        let fontFamily = self.modifiedFamilyName(forFontFamily: familyName)
        #if os(iOS) || os(tvOS) || os(watchOS)
            if UIFont.familyNames.contains(fontFamily) {
                fontNames.append(contentsOf: UIFont.fontNames(forFamilyName: fontFamily))
            }
        #else
            let fontManager = NSFontManager.shared
            if fontManager.availableFontFamilies.contains(fontFamily) {
                if let fontMembers = fontManager.availableMembers(ofFontFamily: fontFamily) {
                    for fontDetails in fontMembers {
                        let fontName = String(describing: fontDetails[0])
                        fontNames.append(fontName)
                    }
                }
            }
        #endif
        return fontNames
    }

    /// Default font name for given font style ID
    func getDefaultFontId(forStyle styleId: String) -> String {
        #if os(macOS)
            return [
                "100": "HelveticaNeue-Thin", "100i": "HelveticaNeue-ThinItalic",
                "200": "HelveticaNeue-UltraLight", "200i": "HelveticaNeue-UltraLightItalic",
                "300": "HelveticaNeue-Light", "300i": "HelveticaNeue-LightItalic",
                "400": "HelveticaNeue", "400i": "HelveticaNeue-Italic",
                "500": "HelveticaNeue-Medium", "500i": "HelveticaNeue-MediumItalic",
                "600": "HelveticaNeue-Medium", "600i": "HelveticaNeue-MediumItalic",
                "700": "HelveticaNeue-Bold", "700i": "HelveticaNeue-BoldItalic",
                "800": "HelveticaNeue-Bold", "800i": "HelveticaNeue-BoldItalic",
                "900": "HelveticaNeue-Bold", "900i": "HelveticaNeue-BoldItalic"
            ][styleId] ?? "HelveticaNeue"
        #else
            return [
                "100": "AvenirNext-UltraLight", "100i": "AvenirNext-UltraLightItalic",
                "200": "AvenirNext-UltraLight", "200i": "AvenirNext-UltraLightItalic",
                "300": "AvenirNext-UltraLight", "300i": "AvenirNext-UltraLightItalic",
                "400": "AvenirNext-Regular", "400i": "AvenirNext-Italic",
                "500": "AvenirNext-Medium", "500i": "AvenirNext-MediumItalic",
                "600": "AvenirNext-DemiBold", "600i": "AvenirNext-DemiBoldItalic",
                "700": "AvenirNext-Bold", "700i": "AvenirNext-BoldItalic",
                "800": "AvenirNext-Heavy", "800i": "AvenirNext-HeavyItalic",
                "900": "AvenirNext-Heavy", "900i": "AvenirNext-HeavyItalic"
            ][styleId] ?? "AvenirNext-Regular"
        #endif
    }
}

// MARK: - Font Weight and Style ID

public extension FontHandler {
    /// Style ID for font name
    ///
    /// - Parameter fName: Postscript name of font
    /// - Returns: A String defining style information for given font name
    func getStyleId(forFont fName: String) -> String {
        var styleId = "400"
        let nwp = "[^A-Za-z\\d]*"
        let fontName = fName.lowercased()

        if fontName.matches("thin") {
            styleId = fontName.matches("(italic|oblique)") ? "100i" : "100"
        } else if fontName.matches("(ultra|extra)\(nwp)light") {
            styleId = fontName.matches("(italic|oblique)") ? "200i" : "200"
        } else if fontName.matches("light") { // should be below 'ultralight' condition check
            styleId = fontName.matches("(italic|oblique)") ? "300i" : "300"
        } else if fontName.matches("medium") {
            styleId = fontName.matches("(italic|oblique)") ? "500i" : "500"
        } else if fontName.matches("(semi|demi)\(nwp)bold") {
            styleId = fontName.matches("(italic|oblique)") ? "600i" : "600"
        } else if fontName.matches("(ultra|extra)\(nwp)bold|heavy") {
            styleId = fontName.matches("(italic|oblique)") ? "800i" : "800"
        } else if fontName.matches("bold|solid") { // should be below 'extrabold', 'semibold' and 'demibold' condition checks
            styleId = fontName.matches("(italic|oblique)") ? "700i" : "700"
        } else if fontName.matches("black") {
            styleId = fontName.matches("(italic|oblique)") ? "900i" : "900"
        } else {
            styleId = fontName.matches("(italic|oblique)") ? "400i" : "400"
        }
        return styleId
    }

    /// Font Weight Label for style ID
    ///
    /// - Parameter styleId: A String which defines style information of font
    /// - Returns: A String which will be displayed on Right Panel Popover button
    func getFontWeightLabel(forStyle styleId: String) -> String? {
        self.fontStyleIdWeightLabelMap[styleId]
    }
}

// MARK: - Misc

public extension FontHandler {
    func convertPixelValueToPoints(
        pixelValue: CGFloat,
        scale: CGFloat = 1.0
    ) -> CGFloat {
        round((pixelValue / scale) * (3.0 / 4.0))
    }

    func convertPointValueToPixels(
        pointValue: CGFloat,
        scale: CGFloat = 1.0
    ) -> CGFloat {
        round((pointValue * scale) * (4.0 / 3.0))
    }
}

// MARK: - Font Id and Style Id Validation

private extension FontHandler {
    func isValidFontName(_ name: String, forWeight weight: String, withStyleId styleId: String) -> Bool {
        let nwp = "[^A-Za-z\\d]*"
        let fontName = name.lowercased()

        if !styleId.contains("i") && fontName.matches("(italic|oblique)") {
            return false
        }

        let italicPattern = "(italic|oblique)"
        let invalidThinPattern = "(ultra|extra)\(nwp)light"
        let invalidThinItalicPattern = "\(invalidThinPattern)\(italicPattern)"
        let invalidRegularPattern = "book"
        let invalidItalicPattern = "ultra|extra|thin|light|book|medium|semi|demi|bold|heavy|black"
        let invalidBoldPattern = "(semi|demi|extra)\(nwp)bold"
        let invalidBoldItalicPattern = "\(invalidBoldPattern)\(italicPattern)"

        if (weight.isEmpty && fontName.range(of: "-", options: .backwards) == nil) ||
            fontName.contains(weight.lowercased()) {
            if styleId == "300" && fontName.matches(invalidThinPattern) ||
                styleId == "300i" && fontName.matches(invalidThinItalicPattern) ||
                styleId == "400" && fontName.matches(invalidRegularPattern) ||
                styleId == "400i" && fontName.matches(invalidItalicPattern) ||
                styleId == "700" && fontName.matches(invalidBoldPattern) ||
                styleId == "700i" && fontName.matches(invalidBoldItalicPattern) {
                return false
            }
            return true
        }
        return false
    }
}
