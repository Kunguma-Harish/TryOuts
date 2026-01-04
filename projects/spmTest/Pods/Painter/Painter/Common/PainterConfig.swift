//
//  PainterConfig.swift
//  Painter
//
//  Created by Jaganraj Palanivel on 28/07/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

public class PainterConfig {
	public struct DataFieldInfo {
		public let value: String
		public let bgColor: DeviceColor?

		public static let `default` = DataFieldInfo(value: "", bgColor: nil)

		public init(value: String, bgColor: DeviceColor? = nil) {
			self.value = value
			self.bgColor = bgColor
		}
	}

	// MARK: - Private Properties

	private let imageHandler: ((Proto.Picture, CGRect, CGSize, CGFloat, String?) -> CGImage?)?
	private let pictureFillHandler: ((PictureFill, String?, CGSize, CGFloat, String?) -> PictureFillImageData?)?
	private let imageFilterHandler: ((PictureValue, PictureProperties, CGRect, CGSize, CGFloat, String) -> CGImage?)?
	private let presetHandler: ((RenderingContext, PainterConfig, OrientationMatrices) -> Void)?
	private let fontHandler: ((String, String) -> String?)?
	private let smartObjectHandler: ((ShapeObject.GroupShape, Bool, String?) -> ShapeObject.GroupShape)?
	private let overrideHandler: ((ShapeObject.GroupShape, String?) -> ShapeObject.GroupShape)?
	private let shadowImageHandler: ((Bool, String, Int, CGFloat, CGImage?) -> (CGImage, CGSize)?)?
	private let fillImageHandler: ((Bool, String, Int, CGFloat, CGImage?, CGSize?) -> CGImage?)?
	private let propsHandler: ((ShapeObject, String?) -> ShapeObject)?
	private let dataLinkHandler: ((String, String?) -> DataFieldInfo)?
	private let dataFieldIdForName: ((String) -> String?)?
	private let highlightColorAlpha: ((String?) -> CGFloat?)?

	public var documentID: String?
	public var cache: PainterCache?
	public let fontShapes: [FontShape]
	let shadowBitmapConstants: BitmapConstants?

	public init(
		documentID: String? = nil,
		imageHandler: ((Proto.Picture, CGRect, CGSize, CGFloat, String?) -> CGImage?)? = nil,
		pictureFillHandler: ((PictureFill, String?, CGSize, CGFloat, String?) -> PictureFillImageData?)? = nil,
		imageFilterHandler: ((PictureValue, PictureProperties, CGRect, CGSize, CGFloat, String) -> CGImage?)? = nil,
		presetHandler: ((RenderingContext, PainterConfig, OrientationMatrices) -> Void)? = nil,
		fontHandler: ((String, String) -> String?)? = nil,
		smartObjectHandler: ((ShapeObject.GroupShape, Bool, String?) -> ShapeObject.GroupShape)? = nil,
		overrideHandler: ((ShapeObject.GroupShape, String?) -> ShapeObject.GroupShape)? = nil,
		shadowImageHandler: ((Bool, String, Int, CGFloat, CGImage?) -> (CGImage, CGSize)?)? = nil,
		fillImageHandler: ((Bool, String, Int, CGFloat, CGImage?, CGSize?) -> CGImage?)? = nil,
		shadowBitmapConstants: BitmapConstants? = nil,
		propsHandler: ((ShapeObject, String?) -> ShapeObject)? = nil,
		dataLinkHandler: ((String, String?) -> DataFieldInfo)? = nil,
		dataFieldIdForName: ((String) -> String?)? = nil,
		cache: PainterCache? = nil,
		fontShapes: [FontShape]? = nil,
		highlightColorAlpha: ((String?) -> CGFloat?)? = nil,
		dataFieldsBGColor: DeviceColor? = nil) {
		self.documentID = documentID
		self.imageHandler = imageHandler
		self.pictureFillHandler = pictureFillHandler
		self.imageFilterHandler = imageFilterHandler
		self.presetHandler = presetHandler
		self.fontHandler = fontHandler
		self.smartObjectHandler = smartObjectHandler
		self.overrideHandler = overrideHandler
		self.shadowImageHandler = shadowImageHandler
		self.fillImageHandler = fillImageHandler
		self.shadowBitmapConstants = shadowBitmapConstants
		self.propsHandler = propsHandler
		self.dataLinkHandler = dataLinkHandler
		self.dataFieldIdForName = dataFieldIdForName
		self.cache = cache
		self.fontShapes = fontShapes ?? []
		self.highlightColorAlpha = highlightColorAlpha
	}

	public func switchingDocument(newDocumentID: String?, newCahe: PainterCache?) {
		self.documentID = newDocumentID
		self.cache = newCahe
	}

	// Made getPicture(Proto.Picture) and getPicture(PictureFill) public because SVGKit uses these methods.
	public func getPicture(picture: Proto.Picture, for rect: CGRect, size: CGSize, level: CGFloat) -> CGImage? {
		return self.imageHandler?(picture, rect, size, level, self.documentID)
	}

	func getFilteredImage(picture: PictureValue, picprops: PictureProperties, for rect: CGRect, size: CGSize, level: CGFloat) -> CGImage? {
		return self.imageFilterHandler?(picture, picprops, rect, size, level, self.documentID ?? "")
	}

	public func getPicturFillOnlyConfig() -> PainterConfig {
		let config = PainterConfig(documentID: self.documentID, pictureFillHandler: self.pictureFillHandler, imageFilterHandler: self.imageFilterHandler)
		return config
	}

	public func getPicture(from pictureFill: PictureFill, forId id: String?, size: CGSize, level: CGFloat) -> PictureFillImageData? {
		return self.pictureFillHandler?(pictureFill, id, size, level, self.documentID)
	}

	func getSmartObject(forShapeObject shapeObject: ShapeObject.GroupShape, withVisualTransform: Bool) -> ShapeObject.GroupShape? {
		return self.smartObjectHandler?(shapeObject, withVisualTransform, self.documentID)
	}

	func getFontId(forFamily familyName: String, forStyle styleId: String) -> String? {
		return self.fontHandler?(familyName, styleId)
	}

	func getOverriddenValue(for groupShape: ShapeObject.GroupShape) -> ShapeObject.GroupShape? {
		return self.overrideHandler?(groupShape, self.documentID)
	}

	func getMergedProps(for shapeObject: ShapeObject) -> ShapeObject? {
		return self.propsHandler?(shapeObject, self.documentID)
	}

	public func getHighlightColorAlpha(shapeId: String?) -> CGFloat {
		return self.highlightColorAlpha?(shapeId) ?? 1
	}

	public func getDataFieldInfo(
		forDataLinkId dLinkId: String,
		shapeId: String?) -> DataFieldInfo? {
		return self.dataLinkHandler?(dLinkId, shapeId)
	}

	public func getDataFieldIdForName(forDataFieldName dName: String) -> String? {
		return self.dataFieldIdForName?(dName)
	}

	func drawConnector(in ctx: RenderingContext, matrix: OrientationMatrices) {
		self.presetHandler?(ctx, self, matrix)
	}

	func getShadowImage(for id: String, hashValue: Int, level: CGFloat) -> (CGImage, CGSize)? {
		return self.shadowImageHandler?(true, id, hashValue, level, nil)
	}

	func setShadowImage(for id: String, hashValue: Int, image: CGImage) {
		_ = self.shadowImageHandler?(false, id, hashValue, 1.0, image)
	}

	func setFillImage(for id: String, hashValue: Int, image: CGImage) {
		_ = self.fillImageHandler?(false, id, hashValue, 1.0, image, nil)
	}

	func getFillImage(for id: String, hashValue: Int, level: CGFloat, size: CGSize) -> CGImage? {
		return self.fillImageHandler?(true, id, hashValue, level, nil, size)
	}

	// Below values are static because these values do not change across an application or a device
	// Note: Initialized with startwith default values
	public static var defaultFontSize: Float = 12 // 18 for show and 12 for startwith
	public static var shouldConvertFontSizeToPixels = false // true for show and false for startwith
	public static var defaultVerticalTextAlignment = VerticalAlignType.top // 'Top' for startwith and 'middle' for show

	static var multiPathPresets: [GeometryField.PresetShapeGeometry] = [
		.can, .cube, .bevel, .foldedCorner, .smiley, .cloud, .curvedRightArrow,
		.curvedLeftArrow, .curvedUpArrow, .curvedDownArrow, .borderCallout1,
		.borderCallout2, .borderCallout3, .accentCallout1, .accentCallout2,
		.accentCallout3, .callout1, .callout2, .callout3, .accentBorderCallout1,
		.accentBorderCallout2, .accentBorderCallout3, .cloudCallout, .actionPrevious,
		.actionNext, .actionBegin, .actionEnd, .actionHome, .actionInformation,
		.actionReturn, .actionMovie, .actionDocument, .actionSound, .actionHelp,
		.multiDocument, .upRibbon, .downRibbon, .curvedUpRibbon, .curvedDownRibbon,
		.verticalScroll, .horizontalScroll, .twoEdgedFrame, .fourEdgedFrame,
		.topBanner, .dottedSign, .squareOnCircleBoard, .borderQuote, .rectQuote,
		.circleQuote, .man, .woman, .clockNeedle, .modCan, .audio
	]

	static var smartPresets: [GeometryField.PresetShapeGeometry] = [
		.blockArc, .circleFiller, .modRoundRect, .horizontalSlider, .verticalSlider,
		.modParallelogram, .ellipseFiller, .modRect, .man, .woman, .roundRect, .meterNeedle,
		.clockNeedle, .modCan
	]

	static var textPresets: [GeometryField.PresetShapeGeometry] = [
		.twoEdgedFrame,
		.fourEdgedFrame,
		.topBanner,
		.dottedSign,
		.squareOnCircleBoard,
		.borderQuote,
		.rectQuote,
		.circleQuote
	]

	static func actualFontSize(forSize size: Float) -> Float {
		if self.shouldConvertFontSizeToPixels {
			return Float(pointToPixel(CGFloat(size)))
		}
		return size
	}

	static func actualPortionFontSize(forSize size: Float) -> Float {
		if self.shouldConvertFontSizeToPixels {
			return Float(pixelToPoint(CGFloat(size)))
		}
		return size
	}
}

public class RenderingContext {
	public let cgContext: CGContext
	public let zoomFactor: CGFloat // 1.0 = 100%
	public var scaleRatio: CGFloat = 1.0 // For mobile apps with varying device sizes. Especially for Show
	public let isPDFContext: Bool

	/// Shadow's vertical displacement is inverted when drawing into a bitmap context created manually for blur.
	/// To compensate that, shadow drawing will check if this value is true and if true, will multiply shadow's vetical displacement by -1.
	/// For iOS it should be set as true always, for macOS it should be set as true while drawing blur
	let verticallyFlipShadow: Bool

	/// stores the initial transform of cgContext
	let initialTransform: CGAffineTransform

	/// UUID of the shape whose text content is being edited by the user.
	/// The shape with this ID will not be rendered.
	public var editingTextID: String?

	/// UUID of the shape that is being edited and its parents.
	public var editingShapeIds: [String] = []

	public init(ctx: CGContext, zoomFactor: CGFloat = 1.0, canDrawEffects: Bool = true, vFlipShadow: Bool = false, isPDFContext: Bool = false) {
		self.cgContext = ctx
		self.zoomFactor = zoomFactor
		self.verticallyFlipShadow = vFlipShadow
		self.initialTransform = ctx.ctm
		self.isPDFContext = isPDFContext
	}
}

// Various bitmap options are added to find the performance in trial and error method :)
public class BitmapConstants {
	public var colorSpace: CGColorSpace
	public var bitmapInfo: CGBitmapInfo
	public var bitsPerComponent: Int

	// swiftlint:disable force_unwrapping
	private static var srgbColorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
	// swiftlint:enable force_unwrapping

	private init(cs: CGColorSpace, info: CGBitmapInfo, bits: Int) {
		self.colorSpace = cs
		self.bitmapInfo = info
		self.bitsPerComponent = bits
	}

	static let deviceRGB8: BitmapConstants = {
		let premultipliedLast = CGImageAlphaInfo.premultipliedLast.rawValue

		let cs = CGColorSpaceCreateDeviceRGB()
		let info = CGBitmapInfo(rawValue: premultipliedLast)
		let bits = 8

		let bitmap = BitmapConstants(cs: cs, info: info, bits: bits)
		return bitmap
	}()

	static let sRGB8: BitmapConstants = {
		let premultipliedLast = CGImageAlphaInfo.premultipliedLast.rawValue

		let cs = BitmapConstants.srgbColorSpace
		let info = CGBitmapInfo(rawValue: premultipliedLast)
		let bits = 8

		let bitmap = BitmapConstants(cs: cs, info: info, bits: bits)
		return bitmap
	}()

	static let deviceRGB16: BitmapConstants = {
		let premultipliedLast = CGImageAlphaInfo.premultipliedLast.rawValue
		let floatComponents = CGBitmapInfo.floatComponents.rawValue
		let order16Little = CGImageByteOrderInfo.order16Little.rawValue
		let combinedValue = premultipliedLast | floatComponents | order16Little

		let cs = CGColorSpaceCreateDeviceRGB()
		let info = CGBitmapInfo(rawValue: combinedValue)
		let bits = 16

		let bitmap = BitmapConstants(cs: cs, info: info, bits: bits)
		return bitmap
	}()

	static let sRGB16: BitmapConstants = {
		let premultipliedLast = CGImageAlphaInfo.premultipliedLast.rawValue
		let floatComponents = CGBitmapInfo.floatComponents.rawValue
		let order16Little = CGImageByteOrderInfo.order16Little.rawValue
		let combinedValue = premultipliedLast | floatComponents | order16Little

		let cs = BitmapConstants.srgbColorSpace
		let info = CGBitmapInfo(rawValue: combinedValue)
		let bits = 16

		let bitmap = BitmapConstants(cs: cs, info: info, bits: bits)
		return bitmap
	}()

	static let deviceRGB32: BitmapConstants = {
		let premultipliedLast = CGImageAlphaInfo.premultipliedLast.rawValue
		let floatComponents = CGBitmapInfo.floatComponents.rawValue
		let order32Little = CGImageByteOrderInfo.order32Little.rawValue
		let combinedValue = premultipliedLast | floatComponents | order32Little

		let cs = CGColorSpaceCreateDeviceRGB()
		let info = CGBitmapInfo(rawValue: combinedValue)
		let bits = 32

		let bitmap = BitmapConstants(cs: cs, info: info, bits: bits)
		return bitmap
	}()

	static let sRGB32: BitmapConstants = {
		let premultipliedLast = CGImageAlphaInfo.premultipliedLast.rawValue
		let floatComponents = CGBitmapInfo.floatComponents.rawValue
		let order32Little = CGImageByteOrderInfo.order32Little.rawValue
		let combinedValue = premultipliedLast | floatComponents | order32Little

		let cs = BitmapConstants.srgbColorSpace
		let info = CGBitmapInfo(rawValue: combinedValue)
		let bits = 32

		let bitmap = BitmapConstants(cs: cs, info: info, bits: bits)
		return bitmap
	}()

	static let bitmapConstants: [BitmapConstants] = [.deviceRGB8, .sRGB8, .deviceRGB16, .sRGB16, .deviceRGB32, .sRGB32]
	public static let currentBitmapConstant = BitmapConstants.bitmapConstants[3]
}
