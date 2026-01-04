//
//  TextAsPath.swift
//  Painter
//
//  Created by Sarath Kumar G on 27/03/20.
//  Copyright © 2020 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

public struct TextAsPath {
	public var paths: [CGPath]
	public var characters: [String]
	public var textLayerProps: TextLayerProperties
}

public extension Array where Element == TextAsPath {
	var boundingBoxOfPaths: CGRect {
		return self.reduce(CGRect.null) { currentUnionRect, currentPathData -> CGRect in
			let rectForPathsArray = currentPathData.paths.reduce(CGRect.null) { subUnionRect, path -> CGRect in
				path.boundingBoxOfPath.union(subUnionRect)
			}
			return rectForPathsArray.union(currentUnionRect)
		}
	}
}
