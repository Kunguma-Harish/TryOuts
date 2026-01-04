//
//  ShowFontManager.swift
//  GraphikosAppleAssets
//
//  Created by madhu-8287 on 09/10/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import CoreText
import Foundation

public class ShowFontManager: NSObject {
    enum FontHandlingError: Error {
        case invalidPostscriptName
        case fontsBundlePathUnavailable
        case invalidFontDownloadURL
        case emptyWebFontDownloadData
        case invalidFontDownloadState
    }

    public typealias StyleId = String
    public typealias FamilyName = String
    public typealias ClassName = String
    public typealias FontPostscriptName = String
    public typealias FontStylesMap = [StyleId: FontPostscriptName]
    public typealias FontDownloadCompletionBlock = (Bool) -> Void

    public static let shared = ShowFontManager()

    private final let fontsDownloadQueue = DispatchQueue(
        label: "com.zoho.graphikosappleasssets.fontsDownloadQueue",
        qos: .background
    )

    private final let fontRequestsAccessQueue = DispatchQueue(
        label: "com.zoho.graphikosappleasssets.fontRequestsAccessQueue",
        qos: .background
    )

    private final let fontIdGenerationQueue = DispatchQueue(
        label: "com.zoho.graphikosappleasssets.fontIdGenerationQueue",
        qos: .userInteractive
    )

    private final let fontIdsAccessQueue = DispatchQueue(
        label: "com.zoho.graphikosappleasssets.fontIdsAccessQueue",
        attributes: .concurrent
    )

    private var fontRequestsInProgress = [String: [ClassName: FontDownloadCompletionBlock]]()

    /// Cache which maintains mappings for postscript name (font name after it's installed on device) with FontFamily and its style ID
    ///  (e.g) FontFamily: "Avenir Next"; StyleID: "400"; PostscriptName: "AvenirNext-Regular"
    ///  Sample entry: ["Avenir Next_400": "AvenirNext-Regular"]
    private var fontIdsMap = [String: FontPostscriptName]()

    /// Cache which maintains another dictionary of font style IDs and it's postscript names ([StyleID: FontPostscriptName]) for given FontFamily of both bundled fonts and web fonts
    /// (e.g) FontFamily: "League Gothic"; Style IDs:  ["400", "400i"]; fontName: ["LeagueGothic-Regular", "LeagueGothic-Italic"];
    /// Sample entry: ["Antic Slab": ["400": "LeagueGothic-Regular", "400i": "LeagueGothic-Italic"]
    private var fontStylesMap = [FamilyName: FontStylesMap]()

    /// Cache which maintains dictionary of font style IDs and it's postscript names ([StyleID: FontPostscriptName]) for given FontFamily of only web fonts
    private var _webFontStylesMap = [FamilyName: FontStylesMap]()

    /// Cache which maintains dictionary of font style IDs and it's postscript names ([StyleID: FontPostscriptName]) for given FontFamily of only bundled fonts
    public var bundleFontStylesMap = [FamilyName: FontStylesMap]()

    override private init() {
        super.init()
        loadFontStylesFromLocalStorage()
        loadWebFontStylesFromLocalStorage()
    }

    deinit {
        Debugger.deInit(self.classForCoder)
    }
}

public extension ShowFontManager {
    var webFontsStylesMap: [String: [String: String]] {
        self._webFontStylesMap
    }

    func getFontId(
        for familyName: FamilyName,
        with styleId: StyleId = "400",
        requestedBy requester: ClassName? = nil,
        completionBlock: ((Bool) -> Void)? = nil
    ) -> String? {
        var actualFamilyName = familyName
        var actualStyleId = styleId
        if let font = PlatformFont(name: familyName, size: 20), font.fontFamilyName != familyName {
            actualFamilyName = font.fontFamilyName
            actualStyleId = FontHandler.shared.getStyleId(forFont: font.fontName)
        }
        let fontIdKeyString = "\(actualFamilyName)_\(actualStyleId)"
        if let fontId = self.getFontId(forKey: fontIdKeyString) {
            return fontId
        }
        self.fontIdGenerationQueue.async {
            _ = self.generateFontId(
                for: actualFamilyName,
                with: actualStyleId,
                requestedBy: requester,
                completionBlock: completionBlock
            )
        }
        return nil
    }

    /// Use this method only when required for TextStorage update operations
    func getFontIdInSync(
        for familyName: FamilyName,
        with styleId: StyleId
    ) -> String? {
        let fontIdKeyString = "\(familyName)_\(styleId)"
        if let fontId = self.getFontId(forKey: fontIdKeyString) {
            return fontId
        }
        return generateFontId(for: familyName, with: styleId)
    }

    func getFontStylesMap(for familyName: FamilyName) -> FontStylesMap? {
        self.bundleFontStylesMap[familyName] ??
            self.webFontsStylesMap[familyName] ??
            self.fontStylesMap[familyName]
    }

    func originalFamilyName(forFontFamily fontFamily: String) -> FamilyName {
        if fontFamily.contains("Raleway Dots ") {
            return "Raleway Dots"
        }
        return fontFamily
    }

    func hasMultipleFontWeights(forFontFamily familyName: String) -> Bool {
        var hasMultipleFontWeights = false
        if let fontStyles = bundleFontStylesMap[familyName] {
            // Check whether the familyName is present in bundled fonts list
            hasMultipleFontWeights = fontStyles.count > 1
        } else if FontHandler.shared.isAvailable(fontFamily: familyName) {
            hasMultipleFontWeights = FontHandler.shared.getFontNames(forFamily: familyName).count > 1
        }
        return hasMultipleFontWeights
    }

    func downloadWebFont(
        familyName: FamilyName,
        styleId: StyleId,
        completionBlock: @escaping (Bool, String?) -> Void
    ) {
        guard let webfontstyles = _webFontStylesMap[familyName] else {
            completionBlock(false, "\(familyName) is not available in server")
            return // Not a Web Font
        }
        if isFontInstalledOnDevice(familyName, styleId) {
            completionBlock(true, nil)
            return
        }

        var urlFontName: String?
        if webfontstyles.keys.contains(styleId) {
            urlFontName = webfontstyles[styleId]
        } else if !isFontInstalledOnDevice(familyName, styleId),
                  webfontstyles.keys.contains("400") {
            urlFontName = webfontstyles["400"]
        }
        if let urlFontName {
            self.downloadWebFont(fontId: urlFontName) { data, error in
                if let error {
                    completionBlock(false, error.localizedDescription)
                } else if let fontData = data {
                    self.handleFontDataOnSuccessfulDownload(
                        fontData, fontFamily: familyName, style: styleId
                    )
                    completionBlock(true, nil)
                } else {
                    let error = "Unknown error dowloading \(familyName)\(styleId)"
                    completionBlock(false, error)
                }
            }
        } else {
            let error = "\(familyName) not found in web fonts map for \(styleId)"
            completionBlock(false, error)
        }
    }
}

extension ShowFontManager {
    var fontsBundleUrl: URL? {
        ResourceBundleType.fonts.resourceURL
    }

    func registerFont(
        fontName: String?,
        bundleUrl: URL,
        success: @escaping (String?) -> Void,
        failure: @escaping (Error) -> Void
    ) {
        if let postscriptName = registerFont(
            withName: fontName,
            bundleUrl: bundleUrl
        ) {
            success(postscriptName)
        } else {
            failure(FontHandlingError.invalidPostscriptName)
        }
    }
}

private extension ShowFontManager {
    enum FontResourceType: String {
        case bundleFonts = "BundleFonts"
        case fontStyles = "FontStyles"
        case webFonts = "WebFonts"
    }

    func getFontResourceUrl(for type: FontResourceType) -> URL? {
        Bundle.getBundle(for: .renderingResources).url(
            forResource: type.rawValue,
            withExtension: "txt"
        )
    }

    func loadFontStylesFromLocalStorage() {
        self.loadBundleFontStylesFromLocalStorage() // Load bundle fonts first
        do {
            guard
                let fontStylesUrl = getFontResourceUrl(for: .fontStyles),
                let fontStylesDict = try JSONSerialization.jsonObject(
                    with: try Data(contentsOf: fontStylesUrl),
                    options: JSONSerialization.ReadingOptions(rawValue: 0)
                ) as? [String: Any]
            else {
                assertionFailure("Error loading font styles in \(#function)")
                return
            }
            for fontName in fontStylesDict.keys {
                if let fontStyles = fontStylesDict[fontName] as? [String: Any],
                   let styles = fontStyles["styles"] as? [String: Any] {
                    var stylesDict = [String: String]()
                    for fontWeight in styles.keys {
                        if let weight = styles[fontWeight] as? [String: String],
                           let fontId = weight["fontId"] {
                            stylesDict[fontWeight] = fontId
                        }
                    }
                    self.fontStylesMap[fontName] = stylesDict
                }
            }
        } catch {
            assertionFailure("Failed to load font styles in \(#function) - \(error)")
        }

        // Append bundle font styles into font styles
        self.bundleFontStylesMap.forEach { key, value in
            self.fontStylesMap[key] = value
        }
    }

    func loadBundleFontStylesFromLocalStorage() {
        do {
            guard
                let bundleFontStylesUrl = getFontResourceUrl(for: .bundleFonts),
                let fontStylesDict = try JSONSerialization.jsonObject(
                    with: try Data(contentsOf: bundleFontStylesUrl),
                    options: JSONSerialization.ReadingOptions(rawValue: 0)
                ) as? [String: Any]
            else {
                assertionFailure("Error loading bundle font styles in \(#function)")
                return
            }
            for fontName in fontStylesDict.keys {
                if let fontStyles = fontStylesDict[fontName] as? [String: Any],
                   let styles = fontStyles["styles"] as? [String: Any] {
                    var stylesDict = [String: String]()
                    for fontWeight in styles.keys {
                        if let weight = styles[fontWeight] as? [String: String],
                           let fontId = weight["fontId"] {
                            stylesDict[fontWeight] = fontId
                        }
                    }
                    self.bundleFontStylesMap[fontName] = stylesDict
                }
            }
        } catch {
            assertionFailure("Failed to load font styles in \(#function) - \(error)")
        }
    }

    func loadWebFontStylesFromLocalStorage() {
        do {
            guard
                let webFontsStylesUrl = getFontResourceUrl(for: .webFonts),
                let fontStylesDict = try JSONSerialization.jsonObject(
                    with: try Data(contentsOf: webFontsStylesUrl),
                    options: JSONSerialization.ReadingOptions(rawValue: 0)
                ) as? [String: Any]
            else {
                assertionFailure("Error loading web fonts styles in \(#function)")
                return
            }
            for fontName in fontStylesDict.keys {
                if let fontStyles = fontStylesDict[fontName] as? [String: Any],
                   let styles = fontStyles["styles"] as? [String: Any] {
                    var stylesDict: [String: String] = [:]
                    for style in styles.keys {
                        if let fontWeight = styles[style] as? [String: String],
                           let fontId = fontWeight["fontId"] {
                            stylesDict[style] = fontId
                        }
                    }
                    self._webFontStylesMap[fontName] = stylesDict
                }
            }
        } catch {
            assertionFailure("Failed to load font styles in \(#function) - \(error)")
        }
    }

    func registerFont(
        withName fontName: String?,
        bundleUrl: URL?
    ) -> FontPostscriptName? {
        let fileType = fontName?.contains("LeagueGothic") == true ? "otf" : "ttf"
        guard
            let bundleUrl,
            let fontsBundle = Bundle(url: bundleUrl),
            let fontPath = fontsBundle.path(forResource: fontName, ofType: fileType),
            let fontData = FileManager.default.contents(atPath: fontPath)
        else {
            return nil
        }
        return self.registerFont(with: fontData)
    }

    func registerFont(with fontData: Data) -> FontPostscriptName? {
        var postscriptName: String?
        guard
            let provider = CGDataProvider(data: fontData as CFData),
            let font = CGFont(provider)
        else {
            assertionFailure("Cannot create Font from '.ttf' file")
            return postscriptName
        }
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            Debugger.debug("Error registering font - \(String(describing: CFErrorCopyDescription(error?.takeRetainedValue())))")
        } else if let psName = font.postScriptName {
            postscriptName = psName as String
        }
        return postscriptName
    }

    func handleFontDataOnSuccessfulDownload(
        _ data: Data,
        fontFamily: FamilyName,
        style: StyleId
    ) {
        guard
            !self.isFontInstalledOnDevice(fontFamily, style),
            let fontName = registerFont(with: data)
        else {
            return
        }
        self.updateFontStylesMap(
            fontName: fontName,
            styleId: style,
            familyName: fontFamily
        )
    }

    func isFontInstalledOnDevice(
        _ fontName: String,
        _ fontStyle: String
    ) -> Bool {
        FontHandler.shared.isAvailable(fontFamily: fontName) ||
            (self.fontStylesMap[fontName]?.keys.contains(fontStyle) ?? false)
    }

    func updateFontStylesMap(
        fontName: FontPostscriptName,
        styleId: StyleId,
        familyName: FamilyName
    ) {
        if self.fontStylesMap.keys.contains(familyName) {
            self.fontStylesMap[familyName]?[styleId] = fontName
        } else {
            self.fontStylesMap[familyName] = [styleId: fontName]
        }
    }

    func downloadWebFont(
        fontId: String,
        completionBlock: @escaping (Data?, Error?) -> Void
    ) {
        let domainPrefix = "https://"
        let domain = "webfonts.zohostatic"
        let tld = ".com"
        let urlString = "\(domainPrefix)\(domain)\(tld)/\(fontId)/font.ttf"
        guard let url = URL(string: urlString) else {
            completionBlock(nil, FontHandlingError.invalidFontDownloadURL)
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            if let data {
                completionBlock(data, nil)
            } else if let error {
                completionBlock(nil, error)
            } else {
                completionBlock(nil, FontHandlingError.invalidFontDownloadState)
            }
        }
        dataTask.resume()
    }

    func generateFontId(
        for familyName: FamilyName,
        with styleId: StyleId,
        requestedBy requester: ClassName? = nil,
        completionBlock: ((Bool) -> Void)? = nil
    ) -> String? {
        var fontName: String?
        let fontIdKeyString = "\(familyName)_\(styleId)"

        func cacheFontName(_ fontName: String?) {
            self.fontIdsAccessQueue.async(flags: .barrier) {
                self.fontIdsMap[fontIdKeyString] = fontName
            }
            completionBlock?(true)
        }

        if let fontStyles = self.getFontStylesMap(for: familyName) {
            if let fontId = fontStyles[styleId] {
                let postscriptName = FontHandler.shared.getPostscriptName(
                    forFamily: familyName,
                    withStyle: styleId
                )
                // If the font is already installed on device, use it's postscript name
                // Otherwise use the font name from font styles map which denotes the name of .ttf file to register
                fontName = postscriptName ?? fontId
            } else {
                if styleId.contains("i") {
                    // Check whether non-italic style exists for corresponding styleId
                    let styleIdWithoutItalic = String(styleId.dropLast())
                    fontName = fontStyles[styleIdWithoutItalic]

                    if fontName == nil { // Check whether default italic style exists
                        fontName = fontStyles["400i"]
                    }
                }
                if fontName == nil { // Check whether 'regular' style exists or use family name
                    fontName = fontStyles["400"] ?? familyName
                }
            }
        }

        if let fontId = fontName,
           FontHandler.shared.isAvailable(fontName: fontId, familyName: familyName) {
            cacheFontName(fontId)
        }

        // 1) 'fontId' is incorrect (or) 2) 'fontName' is not installed on target device
        if fontName == nil || !FontHandler.shared.isAvailable(fontName: fontName, familyName: familyName) {
            // Case 1: Get PostScript name of font assuming it is installed on device
            var postscriptName = FontHandler.shared.getPostscriptName(
                forFamily: familyName,
                withStyle: styleId
            )

            if postscriptName == nil { // Case 2: Font is not installed on target device
                if fontName != nil { // Install font using ".ttf" from fonts bundle
                    self.registerFontFromLocalStorage(
                        fontName: fontName,
                        success: { actualFontName in
                            postscriptName = actualFontName
                            handleFontFileAbsenceOnDevice()
                        },
                        failure: { error in
                            Debugger.warn("Failed to register \(String(describing: fontName)) - \(error)")
                        }
                    )
                }
            }

            handleFontFileAbsenceOnDevice()

            func handleFontFileAbsenceOnDevice() {
                if let actualFontName = postscriptName,
                   var fontStyles = self.fontStylesMap[familyName] {
                    fontStyles[styleId] = actualFontName
                    self.fontStylesMap[familyName] = fontStyles // Update 'fontStyles' with registered font's 'PostScriptName'
                }
                if postscriptName == nil { // Absence of ".ttf" file in fonts bundle
                    if let fontStyles = fontStylesMap[familyName] {
                        postscriptName = fontStyles["400"]
                    }
                    if postscriptName == nil { // Absence of 'Regular' style font for 'fontFamily'
                        postscriptName = familyName
                    }
                    if let psName = postscriptName { // 'fontFamily' is different from name of font installed on device
                        let isFontInstalled = FontHandler.shared.isAvailable(
                            fontName: psName,
                            familyName: familyName
                        )
                        fontName = isFontInstalled ? psName : nil

                        if fontName == nil {
                            processFontDownload(
                                for: familyName,
                                with: styleId,
                                requestedBy: requester
                            ) { isSuccessful in
                                if isSuccessful {
                                    cacheFontName(psName)
                                }
                            }
                        }
                    }
                } else {
                    cacheFontName(postscriptName)
                }
            }
        }
        return fontName
    }

    func getFontId(forKey fontIdKey: String) -> FontPostscriptName? {
        var fontId: FontPostscriptName?
        self.fontIdsAccessQueue.sync {
            fontId = self.fontIdsMap[fontIdKey]
        }
        return fontId
    }
}

private extension ShowFontManager {
    func safeGetFontDownloadInProgress(
        for key: String
    ) -> [ClassName: FontDownloadCompletionBlock]? {
        var value: [ClassName: FontDownloadCompletionBlock]?
        self.fontRequestsAccessQueue.sync {
            value = self.fontRequestsInProgress[key]
        }
        return value
    }

    func safeSetFontDownloadInProgress(
        _ value: [ClassName: FontDownloadCompletionBlock],
        for key: String
    ) {
        self.fontRequestsAccessQueue.sync {
            self.fontRequestsInProgress[key] = value
        }
    }

    func safeRemoveFontDownloadInProgress(for key: String) {
        self.fontRequestsAccessQueue.sync {
            _ = self.fontRequestsInProgress.removeValue(forKey: key)
        }
    }

    func processFontDownload(
        for familyName: FamilyName,
        with styleId: StyleId,
        requestedBy requester: ClassName?,
        completionBlock: FontDownloadCompletionBlock?
    ) {
        let fontKeyString = "\(familyName)\(styleId)"
        if let requester, let completionBlock {
            if var blocks = safeGetFontDownloadInProgress(for: fontKeyString) {
                if blocks[requester] == nil {
                    blocks[requester] = completionBlock
                }
                self.safeSetFontDownloadInProgress(blocks, for: fontKeyString)
            } else {
                let blocks = [requester: completionBlock]
                self.safeSetFontDownloadInProgress(blocks, for: fontKeyString)
                self.downloadFont(for: familyName, with: styleId)
            }
        } else {
            if self.safeGetFontDownloadInProgress(for: fontKeyString) == nil {
                self.safeSetFontDownloadInProgress([:], for: fontKeyString)
                self.downloadFont(for: familyName, with: styleId)
            }
        }
    }

    func downloadFont(for familyName: FamilyName, with styleId: StyleId) {
        let fontKeyString = "\(familyName)\(styleId)"
        self.fontsDownloadQueue.async {
            guard NetworkMonitor.shared.isNetworkAvailable else {
                return
            }
            self.downloadWebFont(familyName: familyName, styleId: styleId) { isSuccessful, _ in
                guard isSuccessful else {
                    self.safeRemoveFontDownloadInProgress(for: fontKeyString)
                    //						Debugger.warn("Error downloading web font - \(String(describing: error))")
                    return
                }
                self.safeGetFontDownloadInProgress(for: fontKeyString)?.values.forEach { completionBlock in
                    completionBlock(isSuccessful)
                }
                self.safeRemoveFontDownloadInProgress(for: fontKeyString)
            }
        }
    }
}
