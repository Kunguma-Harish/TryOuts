//
//  PainterCache.swift
//  Painter
//
//  Created by Jaganraj Palanivel on 01/11/17.
//  Copyright © 2017 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

#if os(iOS) || os(tvOS)
import UIKit.NSTextStorage
#elseif os(watchOS)
import UIKit.NSAttributedString
#else
import AppKit.NSTextStorage
#endif

public class PainterCache: NSObject {
	typealias PathWithTransform = (path: CGPath, transHash: Int)
	typealias FrameWithParent = (frame: CGRect, parentId: String?)

	public enum CacheInvalidationType: Int {
		case _default
		case all
		case transform
		case geometry
		case fill
		case stroke
		case opacity
		case shadow
		case blend
		case text
		case refreshFrame
		case blur
		case picture
		case picturecoloradjust
	}

	private var refreshFrameWithControlMap = LRUCache<HashableAnyContainer<String>, AnyContainer<CGRect>>()
	private var rawGeomPathMap = LRUCache<HashableAnyContainer<String>, CGPath>()
	private var rawGeomPathWithoutRadiusMap = LRUCache<HashableAnyContainer<String>, CGPath>()
	/// NOTE:- Change the following two map's to PathWithTransform once the affine matrix code is completely removed.
	private var transformedPathMap = LRUCache<HashableAnyContainer<String>, AnyContainer<[Int: CGPath]>>()
	private var transformedPathWithoutRadiusMap = LRUCache<HashableAnyContainer<String>, AnyContainer<[Int: CGPath]>>()
	private var strokePathMap = LRUCache<HashableAnyContainer<String>, AnyContainer<[Int: CGPath]>>()
	private var combinedShapeToPathMap = LRUCache<HashableAnyContainer<Int>, CGPath>()
	private var combinedShapeToPropsMap = LRUCache<HashableAnyContainer<Int>, AnyContainer<Properties>>()
	private var pictureMap = LRUCache<HashableAnyContainer<String>, CGImage>()
	private var modifiedTransformMap = LRUCache<HashableAnyContainer<String>, AnyContainer<Transform>>()
	private var tableRowHeightsMap = LRUCache<HashableAnyContainer<Int>, AnyContainer<[CGFloat]>>()
	private var tableColWidthsMap = LRUCache<HashableAnyContainer<Int>, AnyContainer<[CGFloat]>>()
	private var textAsPathMap = LRUCache<HashableAnyContainer<String>, AnyContainer<(paths: [TextAsPath], origin: CGPoint)>>()
	private var shapeLevelRefreshFrameMap = LRUCache<HashableAnyContainer<String>, AnyContainer<FrameWithParent>>()
	private var attributedStringMap = LRUCache<HashableAnyContainer<String>, NSMutableAttributedString>()

	private var overridenDataMap = LRUCache<HashableAnyContainer<String>, AnyContainer<ShapeObject.GroupShape>>()
	private var completeObjectDataMap = LRUCache<HashableAnyContainer<String>, AnyContainer<ShapeObject.GroupShape>>()
	private var completeObjectWithVisualTransformDataMap = LRUCache<HashableAnyContainer<String>, AnyContainer<ShapeObject.GroupShape>>()
#if !os(watchOS)
	private var textBoundsMap = LRUCache<HashableAnyContainer<String>, AnyContainer<CGRect>>()
	private var textStorageMap = LRUCache<HashableAnyContainer<String>, AnyContainer<[CGSize: NSTextStorage]>>()

	class BlurImages {
		var withEffects: Blur.BlurImage?
		var withoutEffects: Blur.BlurImage?

		init(withEffects: Blur.BlurImage? = nil, withoutEffects: Blur.BlurImage? = nil) {
			self.withEffects = withEffects
			self.withoutEffects = withoutEffects
		}
	}

	private var blurImageMap = LRUCache<HashableAnyContainer<String>, BlurImages>()
#endif

	func getShapeLevelRefreshFrameMap(for id: String) -> (frame: CGRect, parentId: String?)? {
		let id = HashableAnyContainer<String>(value: id)
		return self.shapeLevelRefreshFrameMap.object(forKey: id)?.value
	}

	func removeShapeLevelRefreshFrameMap(for id: String) {
		let shapeId = HashableAnyContainer<String>(value: id)
		let value = self.shapeLevelRefreshFrameMap.object(forKey: shapeId)?.value
		self.shapeLevelRefreshFrameMap.removeObject(forKey: shapeId)
		self.removeOverridenDataMap(for: id)
		self.removeCompleteObjectDataMap(for: id)

#if !os(watchOS)
		self.textStorageMap.removeObject(forKey: shapeId)
		self.textBoundsMap.removeObject(forKey: shapeId)
		self.removeBlurImageMap(for: id)
#endif
		if let parentId = value?.parentId {
			self.removeShapeLevelRefreshFrameMap(for: parentId)
#if !os(watchOS)
			self.removeBlurImageMap(for: parentId)
#endif
		}
	}

	func hasShapeLevelRefreshFrameMap(for id: String) -> Bool {
		let shapeId = HashableAnyContainer<String>(value: id)
		let value = self.shapeLevelRefreshFrameMap.object(forKey: shapeId)?.value
		if self.shapeLevelRefreshFrameMap.object(forKey: shapeId) != nil {
			return true
		}
		if self.hasOverridenDataMap(for: id) {
			return true
		}
		if self.hasCompleteObjectDataMap(for: id) {
			return true
		}

#if !os(watchOS)
		if self.textStorageMap.object(forKey: shapeId) != nil {
			return true
		}
		if self.textBoundsMap.object(forKey: shapeId) != nil {
			return true
		}
		if self.hasBlurImageMap(for: id) {
			return true
		}
#endif
		if let parentId = value?.parentId {
			if self.hasShapeLevelRefreshFrameMap(for: parentId) {
				return true
			}
#if !os(watchOS)
			if self.hasBlurImageMap(for: parentId) {
				return true
			}
#endif
		}
		return false
	}

	public func setShapeLevelRefreshFrameMap(for id: String, value: (CGRect, String?)) {
		let id = HashableAnyContainer<String>(value: id)
		let object = AnyContainer<FrameWithParent>(value: value)
		self.shapeLevelRefreshFrameMap.setObject(object, forKey: id)
	}

	func getAttributedStringMap(for id: String) -> NSMutableAttributedString? {
		let id = HashableAnyContainer<String>(value: id)
		return self.attributedStringMap.object(forKey: id)
	}

	func removeAttributedStringMap(for id: String) {
		let hashableId = HashableAnyContainer<String>(value: id)
		self.attributedStringMap.removeObject(forKey: hashableId)
		self.removeTextAsPathMap(for: id)
#if !os(watchOS)
		self.textBoundsMap.removeObject(forKey: hashableId)
		self.textStorageMap.removeObject(forKey: hashableId)
#endif
	}

	func hasAttributedStringMap(for id: String) -> Bool {
		let hashableId = HashableAnyContainer<String>(value: id)
		if self.attributedStringMap.object(forKey: hashableId) != nil {
			return true
		}
		if self.hasTextAsPathMap(for: id) {
			return true
		}
#if !os(watchOS)
		if self.textBoundsMap.object(forKey: hashableId) != nil {
			return true
		}
		if self.textStorageMap.object(forKey: hashableId) != nil {
			return true
		}
#endif
		return false
	}

	public func setAttributedStringMap(for id: String, attributedString: NSMutableAttributedString) {
		let id = HashableAnyContainer<String>(value: id)
		self.attributedStringMap.setObject(attributedString, forKey: id)
	}

#if !os(watchOS)
	func getTextBounds(for id: String) -> CGRect? {
		let id = HashableAnyContainer<String>(value: id)
		return self.textBoundsMap.object(forKey: id)?.value
	}

	func setTextBounds(for id: String, bounds: CGRect) {
		let id = HashableAnyContainer<String>(value: id)
		let object = AnyContainer<CGRect>(value: bounds)
		self.textBoundsMap.setObject(object, forKey: id)
	}

	func getTextStorage(for id: String, and rect: CGSize) -> NSTextStorage? {
		let id = HashableAnyContainer<String>(value: id)
		let textStorages = self.textStorageMap.object(forKey: id)?.value
		return textStorages?[rect]
	}

	func setTextStorageMap(for id: String, textStorage: NSTextStorage, with size: CGSize) {
		let id = HashableAnyContainer<String>(value: id)
		var valueDict: [CGSize: NSTextStorage] = [:]
		if let hashDict = self.textStorageMap.object(forKey: id)?.value {
			valueDict = hashDict
			valueDict[size] = textStorage
		} else {
			valueDict = [size: textStorage]
		}
		let object = AnyContainer<[CGSize: NSTextStorage]>(value: valueDict)
		self.textStorageMap.setObject(object, forKey: id)
	}
#endif

	func getRefreshFrameWithControlMapCache(for id: String) -> CGRect? {
		let id = HashableAnyContainer<String>(value: id)
		return self.refreshFrameWithControlMap.object(forKey: id)?.value
	}

	public func setRefreshFrameWithControlMap(for id: String, value: CGRect) {
		let id = HashableAnyContainer<String>(value: id)
		let object = AnyContainer<CGRect>(value: value)
		self.refreshFrameWithControlMap.setObject(object, forKey: id)
	}

	func removeRefreshFrameWithControlMap(for id: String) {
		let id = HashableAnyContainer<String>(value: id)
		self.refreshFrameWithControlMap.removeObject(forKey: id)
	}

	func hasRefreshFrameWithControlMap(for id: String) -> Bool {
		let id = HashableAnyContainer<String>(value: id)
		return self.refreshFrameWithControlMap.object(forKey: id) != nil
	}

	func getRawGeomPathMap(for id: String) -> CGPath? {
		let id = HashableAnyContainer<String>(value: id)
		return self.rawGeomPathMap.object(forKey: id)
	}

	public func setRawGeomPathMap(for id: String, value: CGPath) {
		let id = HashableAnyContainer<String>(value: id)
		self.rawGeomPathMap.setObject(value, forKey: id)
	}

	func removeRawGeomPathMap(for id: String) {
		let id = HashableAnyContainer<String>(value: id)
		self.rawGeomPathMap.removeObject(forKey: id)
	}

	func hasRawGeomPathMap(for id: String) -> Bool {
		let id = HashableAnyContainer<String>(value: id)
		return self.rawGeomPathMap.object(forKey: id) != nil
	}

	func getRawGeomPathWithoutRadiusMap(for id: String) -> CGPath? {
		let id = HashableAnyContainer<String>(value: id)
		return self.rawGeomPathWithoutRadiusMap.object(forKey: id)
	}

	public func setRawGeomPathWithoutRadiusMap(for id: String, value: CGPath) {
		let id = HashableAnyContainer<String>(value: id)
		self.rawGeomPathWithoutRadiusMap.setObject(value, forKey: id)
	}

	func removeRawGeomPathWithoutRadiusMap(for id: String) {
		let id = HashableAnyContainer<String>(value: id)
		self.rawGeomPathWithoutRadiusMap.removeObject(forKey: id)
	}

	func hasRawGeomPathWithoutRadiusMap(for id: String) -> Bool {
		let id = HashableAnyContainer<String>(value: id)
		return self.rawGeomPathWithoutRadiusMap.object(forKey: id) != nil
	}

	func getTransformedPathMap(for id: String, with hash: Int) -> CGPath? {
		let id = HashableAnyContainer<String>(value: id)
		if let hashDict = transformedPathMap.object(forKey: id)?.value {
			return hashDict[hash]
		}
		return nil
	}

	public func setTransformedPathMap(for id: String, value: (CGPath, Int)) {
		let id = HashableAnyContainer<String>(value: id)
		var valueDict: [Int: CGPath] = [:]
		if let hashDict = transformedPathMap.object(forKey: id)?.value {
			valueDict = hashDict
			valueDict[value.1] = value.0
		} else {
			valueDict = [value.1: value.0]
		}
		let object = AnyContainer<[Int: CGPath]>(value: valueDict)
		self.transformedPathMap.setObject(object, forKey: id)
	}

	func removeTransformedPathMap(for id: String) {
		let id = HashableAnyContainer<String>(value: id)
		self.transformedPathMap.removeObject(forKey: id)
	}

	func hasTransformedPathMap(for id: String) -> Bool {
		let id = HashableAnyContainer<String>(value: id)
		return self.transformedPathMap.object(forKey: id) != nil
	}

	func getTransformedPathWithoutRadiusMap(for id: String, with hash: Int) -> CGPath? {
		let id = HashableAnyContainer<String>(value: id)
		if let hashDict = self.transformedPathWithoutRadiusMap.object(forKey: id)?.value {
			return hashDict[hash]
		}
		return nil
	}

	public func setTransformedPathWithoutRadiusMap(for id: String, value: (CGPath, Int)) {
		let id = HashableAnyContainer<String>(value: id)
		var valueDict: [Int: CGPath] = [:]
		if let hashDict = self.transformedPathWithoutRadiusMap.object(forKey: id)?.value {
			valueDict = hashDict
			valueDict[value.1] = value.0
		} else {
			valueDict[value.1] = value.0
		}
		let object = AnyContainer<[Int: CGPath]>(value: valueDict)
		self.transformedPathWithoutRadiusMap.setObject(object, forKey: id)
	}

	func removeTransformedPathWithoutRadiusMap(for id: String) {
		let id = HashableAnyContainer<String>(value: id)
		self.transformedPathWithoutRadiusMap.removeObject(forKey: id)
	}

	func hasTransformedPathWithoutRadiusMap(for id: String) -> Bool {
		let id = HashableAnyContainer<String>(value: id)
		return self.transformedPathWithoutRadiusMap.object(forKey: id) != nil
	}

	func getStrokePathMap(for id: String, with hash: Int) -> CGPath? {
		let id = HashableAnyContainer<String>(value: id)
		if let hashDict = strokePathMap.object(forKey: id)?.value {
			return hashDict[hash]
		}
		return nil
	}

	public func setStrokePathMap(for id: String, value: (CGPath, Int)) {
		let id = HashableAnyContainer<String>(value: id)
		var valueDict: [Int: CGPath] = [:]
		if let hashDict = strokePathMap.object(forKey: id)?.value {
			valueDict = hashDict
			valueDict[value.1] = value.0
		} else {
			valueDict = [value.1: value.0]
		}
		let object = AnyContainer<[Int: CGPath]>(value: valueDict)
		self.strokePathMap.setObject(object, forKey: id)
	}

	func removeStrokePathMap(for id: String) {
		let id = HashableAnyContainer<String>(value: id)
		self.strokePathMap.removeObject(forKey: id)
	}

	func hasStrokePathMap(for id: String) -> Bool {
		let id = HashableAnyContainer<String>(value: id)
		return self.strokePathMap.object(forKey: id) != nil
	}

	func getCombinedShapeToPathMap(for key: Int) -> CGPath? {
		let key = HashableAnyContainer<Int>(value: key)
		return self.combinedShapeToPathMap.object(forKey: key)
	}

	public func setCombinedShapeToPathMap(for key: Int, value: CGPath) {
		let key = HashableAnyContainer<Int>(value: key)
		self.combinedShapeToPathMap.setObject(value, forKey: key)
	}

	func removeCombinedShapeToPathMap(for key: Int) {
		let key = HashableAnyContainer<Int>(value: key)
		self.combinedShapeToPathMap.removeObject(forKey: key)
	}

	func getCombinedShapeToPropsMap(for key: Int) -> Properties? {
		let key = HashableAnyContainer<Int>(value: key)
		return self.combinedShapeToPropsMap.object(forKey: key)?.value
	}

	public func setCombinedShapeToPropsMap(for key: Int, value: Properties) {
		let key = HashableAnyContainer<Int>(value: key)
		let object = AnyContainer<Properties>(value: value)
		self.combinedShapeToPropsMap.setObject(object, forKey: key)
	}

	func removeCombinedShapeToPropsMap(for key: Int) {
		let key = HashableAnyContainer<Int>(value: key)
		self.combinedShapeToPropsMap.removeObject(forKey: key)
	}

	func getModifiedTransformMap(for id: String) -> Transform? {
		let id = HashableAnyContainer<String>(value: id)
		return self.modifiedTransformMap.object(forKey: id)?.value
	}

	public func setModifiedTransformMap(for id: String, value: Transform) {
		let id = HashableAnyContainer<String>(value: id)
		let transform = AnyContainer<Transform>(value: value)
		self.modifiedTransformMap.setObject(transform, forKey: id)
	}

	func removeModifiedTransformMap(for id: String) {
		let id = HashableAnyContainer<String>(value: id)
		self.modifiedTransformMap.removeObject(forKey: id)
	}

	func getPictureMap(for id: String) -> CGImage? {
		let id = HashableAnyContainer<String>(value: id)
		return self.pictureMap.object(forKey: id)
	}

	public func setPictureMap(for id: String, value: CGImage) {
		let id = HashableAnyContainer<String>(value: id)
		self.pictureMap.setObject(value, forKey: id)
	}

	func removePictureMap(for id: String) {
		let id = HashableAnyContainer<String>(value: id)
		self.pictureMap.removeObject(forKey: id)
	}

	func getTableRowHeightsMap(for key: Int) -> [CGFloat]? {
		let key = HashableAnyContainer<Int>(value: key)
		return self.tableRowHeightsMap.object(forKey: key)?.value
	}

	public func setTableRowHeightsMap(for key: Int, value: [CGFloat]) {
		let key = HashableAnyContainer<Int>(value: key)
		let object = AnyContainer<[CGFloat]>(value: value)
		self.tableRowHeightsMap.setObject(object, forKey: key)
	}

	func removeTableRowHeightsMap(for key: Int) {
		let key = HashableAnyContainer<Int>(value: key)
		self.tableRowHeightsMap.removeObject(forKey: key)
	}

	func getTableColWidthsMap(for key: Int) -> [CGFloat]? {
		let key = HashableAnyContainer<Int>(value: key)
		return self.tableColWidthsMap.object(forKey: key)?.value
	}

	public func setTableColWidthsMap(for key: Int, value: [CGFloat]) {
		let key = HashableAnyContainer<Int>(value: key)
		let object = AnyContainer<[CGFloat]>(value: value)
		self.tableColWidthsMap.setObject(object, forKey: key)
	}

	func removeTableColWidthsMap(for key: Int) {
		let key = HashableAnyContainer<Int>(value: key)
		self.tableColWidthsMap.removeObject(forKey: key)
	}

	func getOverridenDataMap(for key: String) -> ShapeObject.GroupShape? {
		let key = HashableAnyContainer<String>(value: key)
		return self.overridenDataMap.object(forKey: key)?.value
	}

	func setOverridenDataMap(for id: String, value: ShapeObject.GroupShape) {
		let key = HashableAnyContainer<String>(value: id)
		let object = AnyContainer<ShapeObject.GroupShape>(value: value)
		self.overridenDataMap.setObject(object, forKey: key)
	}

	func removeOverridenDataMap(for id: String) {
		let key = HashableAnyContainer<String>(value: id)
		self.overridenDataMap.removeObject(forKey: key)

		// If id contains / separated values, then find the first child ID and remove from map for that ID too.
		let firstChildID = String(id.prefix { $0 != "/" })
		if firstChildID.count < id.count {
			let childKey = HashableAnyContainer<String>(value: firstChildID)
			self.overridenDataMap.removeObject(forKey: childKey)
		}
	}

	func hasOverridenDataMap(for id: String) -> Bool {
		let key = HashableAnyContainer<String>(value: id)
		return self.overridenDataMap.object(forKey: key) != nil
	}

	func getCompleteObjectDataMap(for key: String, withVisualTransform: Bool) -> ShapeObject.GroupShape? {
		let key = HashableAnyContainer<String>(value: key)
		if withVisualTransform {
			return self.completeObjectWithVisualTransformDataMap.object(forKey: key)?.value
		} else {
			return self.completeObjectDataMap.object(forKey: key)?.value
		}
	}

	func setCompleteObjectDataMap(for id: String, value: ShapeObject.GroupShape, withVisualTransform: Bool) {
		let key = HashableAnyContainer<String>(value: id)
		let object = AnyContainer<ShapeObject.GroupShape>(value: value)
		if withVisualTransform {
			self.completeObjectWithVisualTransformDataMap.setObject(object, forKey: key)
		} else {
			self.completeObjectDataMap.setObject(object, forKey: key)
		}
	}

	func removeCompleteObjectDataMap(for id: String) {
		let key = HashableAnyContainer<String>(value: id)
		self.completeObjectWithVisualTransformDataMap.removeObject(forKey: key)
		self.completeObjectDataMap.removeObject(forKey: key)
	}

	func hasCompleteObjectDataMap(for id: String) -> Bool {
		let key = HashableAnyContainer<String>(value: id)
		return self.completeObjectWithVisualTransformDataMap.object(forKey: key) != nil || self.completeObjectDataMap.object(forKey: key) != nil
	}

	func getTextAsPathMap(for id: String) -> (paths: [TextAsPath], origin: CGPoint)? {
		let id = HashableAnyContainer<String>(value: id)
		return self.textAsPathMap.object(forKey: id)?.value
	}

	public func setTextAsPathMap(for id: String, value: (paths: [TextAsPath], origin: CGPoint)) {
		let id = HashableAnyContainer<String>(value: id)
		let object = AnyContainer<(paths: [TextAsPath], origin: CGPoint)>(value: value)
		self.textAsPathMap.setObject(object, forKey: id)
	}

	func removeTextAsPathMap(for id: String) {
		let id = HashableAnyContainer<String>(value: id)
		self.textAsPathMap.removeObject(forKey: id)
	}

	func hasTextAsPathMap(for id: String) -> Bool {
		let id = HashableAnyContainer<String>(value: id)
		return self.textAsPathMap.object(forKey: id) != nil
	}

#if !os(watchOS)
	func getBlurImageMap(for id: String) -> BlurImages? {
		let id = HashableAnyContainer<String>(value: id)
		return self.blurImageMap.object(forKey: id)
	}

	func removeBlurImageMap(for id: String) {
		let id = HashableAnyContainer<String>(value: id)
		self.blurImageMap.removeObject(forKey: id)
	}

	func hasBlurImageMap(for id: String) -> Bool {
		let id = HashableAnyContainer<String>(value: id)
		return self.blurImageMap.object(forKey: id) != nil
	}

	func setBlurImageMap(for id: String, imageWithEffects: Blur.BlurImage? = nil, imageWithoutEffects: Blur.BlurImage? = nil) {
		let existingMap = self.getBlurImageMap(for: id)
		let blurImage = BlurImages(
			withEffects: imageWithEffects ?? existingMap?.withEffects,
			withoutEffects: imageWithoutEffects ?? existingMap?.withoutEffects)
		let id = HashableAnyContainer<String>(value: id)
		self.blurImageMap.setObject(blurImage, forKey: id)
	}
#endif
}

extension PainterCache {
	func removeDefaultCaches(for id: String, attributedString: Bool = true) {
		self.removeOverridenDataMap(for: id)
		self.removeCompleteObjectDataMap(for: id)

		if attributedString {
			self.removeAttributedStringMap(for: id)
		}
	}

	func removeCachesForRefreshFrame(for id: String) {
		self.removeShapeLevelRefreshFrameMap(for: id)
		self.removeRefreshFrameWithControlMap(for: id)
	}

	func removeCacheForTransformChanges(for id: String) {
		self.removeDefaultCaches(for: id, attributedString: false)
		self.removeCachesForRefreshFrame(for: id)
		self.removeTransformedPathMap(for: id)
		self.removeTransformedPathWithoutRadiusMap(for: id)
		self.removeStrokePathMap(for: id)
	}

	func removeCachesForGeometryChanges(for id: String) {
		self.removeCacheForTransformChanges(for: id)
		self.removeRawGeomPathMap(for: id)
		self.removeRawGeomPathWithoutRadiusMap(for: id)
	}

	func removeCachesForFillChanges(for id: String) {
		self.removeDefaultCaches(for: id)
	}

	func removeCachesForStrokeChanges(for id: String) {
		self.removeDefaultCaches(for: id)
		self.removeCachesForRefreshFrame(for: id)
		self.removeStrokePathMap(for: id)
	}

	func removeCachesForOpacityChanges(for id: String) {
		self.removeDefaultCaches(for: id)
	}

	func removeCachesForBlendChanges(for id: String) {
		self.removeDefaultCaches(for: id)
	}

	func removeCachesForShadowChanges(for id: String) {
		self.removeDefaultCaches(for: id)
		self.removeCachesForRefreshFrame(for: id)
	}

	func removeCachesForTextChanges(for id: String) {
		self.removeDefaultCaches(for: id)
		self.removeCachesForRefreshFrame(for: id)
	}

	func removeAllCaches(for id: String) {
		self.removeCachesForGeometryChanges(for: id)
		self.removeAttributedStringMap(for: id)
	}

	func hasDefaultCaches(for id: String, attributedString: Bool = true) -> Bool {
		if self.hasOverridenDataMap(for: id) {
			return true
		}
		if self.hasCompleteObjectDataMap(for: id) {
			return true
		}

		if attributedString {
			if self.hasAttributedStringMap(for: id) {
				return true
			}
		}
		return false
	}

	func hasCachesForRefreshFrame(for id: String) -> Bool {
		if self.hasShapeLevelRefreshFrameMap(for: id) {
			return true
		}
		if self.hasRefreshFrameWithControlMap(for: id) {
			return true
		}
		return false
	}

	func hasCacheForTransformChanges(for id: String) -> Bool {
		if self.hasDefaultCaches(for: id, attributedString: false) {
			return true
		}
		if self.hasCachesForRefreshFrame(for: id) {
			return true
		}
		if self.hasTransformedPathMap(for: id) {
			return true
		}
		if self.hasTransformedPathWithoutRadiusMap(for: id) {
			return true
		}
		if self.hasStrokePathMap(for: id) {
			return true
		}
		return false
	}

	func hasCachesForGeometryChanges(for id: String) -> Bool {
		if self.hasCacheForTransformChanges(for: id) {
			return true
		}
		if self.hasRawGeomPathMap(for: id) {
			return true
		}
		if self.hasRawGeomPathWithoutRadiusMap(for: id) {
			return true
		}
		return false
	}

	func hasCachesForFillChanges(for id: String) -> Bool {
		if self.hasDefaultCaches(for: id) {
			return true
		}
		return false
	}

	func hasCachesForStrokeChanges(for id: String) -> Bool {
		if self.hasDefaultCaches(for: id) {
			return true
		}
		if self.hasCachesForRefreshFrame(for: id) {
			return true
		}
		if self.hasStrokePathMap(for: id) {
			return true
		}
		return false
	}

	func hasCachesForOpacityChanges(for id: String) -> Bool {
		return self.hasDefaultCaches(for: id)
	}

	func hasCachesForBlendChanges(for id: String) -> Bool {
		return self.hasDefaultCaches(for: id)
	}

	func hasCachesForShadowChanges(for id: String) -> Bool {
		if self.hasDefaultCaches(for: id) {
			return true
		}
		if self.hasCachesForRefreshFrame(for: id) {
			return true
		}
		return false
	}

	func hasCachesForTextChanges(for id: String) -> Bool {
		if self.hasDefaultCaches(for: id) {
			return true
		}
		if self.hasCachesForRefreshFrame(for: id) {
			return true
		}
		return false
	}

	func hasAllCaches(for id: String) -> Bool {
		if self.hasCachesForGeometryChanges(for: id) {
			return true
		}
		if self.hasAttributedStringMap(for: id) {
			return true
		}
		return false
	}
}

public extension PainterCache {
	func removeCahces(for id: String, with types: [CacheInvalidationType]) {
		for type in types {
			switch type {
			case ._default:
				self.removeDefaultCaches(for: id)
			case .all:
				self.removeAllCaches(for: id)
			case .transform:
				self.removeCacheForTransformChanges(for: id)
			case .geometry:
				self.removeCachesForGeometryChanges(for: id)
			case .fill:
				self.removeCachesForFillChanges(for: id)
			case .stroke:
				self.removeCachesForStrokeChanges(for: id)
			case .opacity:
				self.removeCachesForOpacityChanges(for: id)
			case .shadow:
				self.removeCachesForShadowChanges(for: id)
			case .blend:
				self.removeCachesForBlendChanges(for: id)
			case .text:
				self.removeCachesForTextChanges(for: id)
			case .refreshFrame:
				self.removeCachesForRefreshFrame(for: id)
			case .blur:
				// FIXME: - Yet to implement
				break
			case .picture:
				// FIXME: - Yet to implement
				break
			case .picturecoloradjust:
				// FIXME: - Yet to implement
				break
			}
		}
	}

	func hasCaches(for id: String, with types: [CacheInvalidationType]) -> Bool {
		for type in types {
			switch type {
			case ._default:
				if self.hasDefaultCaches(for: id) {
					return true
				}
			case .all:
				if self.hasAllCaches(for: id) {
					return true
				}
			case .transform:
				if self.hasCacheForTransformChanges(for: id) {
					return true
				}
			case .geometry:
				if self.hasCachesForGeometryChanges(for: id) {
					return true
				}
			case .fill:
				if self.hasCachesForFillChanges(for: id) {
					return true
				}
			case .stroke:
				if self.hasCachesForStrokeChanges(for: id) {
					return true
				}
			case .opacity:
				if self.hasCachesForOpacityChanges(for: id) {
					return true
				}
			case .shadow:
				if self.hasCachesForShadowChanges(for: id) {
					return true
				}
			case .blend:
				if self.hasCachesForBlendChanges(for: id) {
					return true
				}
			case .text:
				if self.hasCachesForTextChanges(for: id) {
					return true
				}
			case .refreshFrame:
				if self.hasCachesForRefreshFrame(for: id) {
					return true
				}
			case .blur:
				// FIXME: - Yet to implement
				break
			case .picture:
				// FIXME: - Yet to implement
				break
			case .picturecoloradjust:
				// FIXME: - Yet to implement
				break
			}
		}
		return false
	}

	func removeAllTextStorageCache() {
		self.textStorageMap.removeAllObjects()
	}
}

public class AnyContainer<T> {
	public let value: T

	public init(value: T) {
		self.value = value
	}
}

public class HashableAnyContainer<T: Hashable>: NSObject {
	public let value: T

	public init(value: T) {
		self.value = value
	}

	override public func isEqual(_ object: Any?) -> Bool {
		guard let other = object as? HashableAnyContainer<T> else {
			return false
		}
		return other.hash == self.hash
	}

	override public var hash: Int {
		return self.value.hashValue
	}
}

extension CGSize: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.width)
		hasher.combine(self.height)
	}
}
