//
//  GraphicFrame+Draw.swift
//  Painter
//
//  Created by lakshman-7016 on 21/08/18.
//  Copyright © 2018 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

public extension GraphicFrame {
	func frame(using config: PainterConfig? = nil) -> CGRect {
		if hasObj {
			let rect = props.transform.rect
			switch obj.type {
			case .chart:
				return rect
			case .table:
				let tableHeight = obj.table.getHeightForTableFrame(using: config).reduce(0, +)
				return CGRect(origin: rect.origin, size: CGSize(width: rect.width, height: tableHeight))
			}
		}
		assertionFailure("Graphic Frame should either have Chart object or Table object")
		return .zero
	}

	func draw(in ctx: RenderingContext, withGroupProps gprops: Properties?, using config: PainterConfig? = nil) {
		if hasObj {
			switch obj.type {
			case .chart:
				obj.chart.draw(in: ctx, within: self.frame(using: config), using: config, forId: nvOprops.nvDprops.id)
			case .table:
				obj.table.draw(in: ctx, within: self.frame(using: config), using: config, forId: nvOprops.nvDprops.id)
			}
		}
	}
}
