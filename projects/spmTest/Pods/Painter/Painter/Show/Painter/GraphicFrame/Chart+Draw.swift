//
//  Chart+Draw.swift
//  Painter
//
//  Created by Sarath Kumar G on 29/10/18.
//  Copyright © 2018 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

// MARK: Chart + Draw

extension Chart {
	/// Draws Chart
	func draw(in ctx: RenderingContext, within rect: CGRect, using config: PainterConfig?, forId id: String) {
		drawBg(in: ctx, filling: rect, using: config, forId: id) // Draw Chart Background

		var chartShape = self.chartShape
		let pos = Position.with {
			$0.left = Float(rect.origin.x)
			$0.top = Float(rect.origin.y)
		}
		chartShape.updateOrigin([pos])

		if obj.hasPlotArea, obj.plotArea.hasProps {
			var plotAreaProps = obj.plotArea.props
			if let chartAreaOrigin = getChartAreaOrigin(from: rect, chartShape: chartShape) {
				plotAreaProps.transform.rect.origin = chartAreaOrigin
			}
			plotAreaProps.draw(in: ctx, withGroupProps: nil, using: config, forId: id, matrix: .identity) // Draw PlotArea
		}
		if hasChartShape {
			chartShape.draw(in: ctx, using: config) // Draw Chart Elements
		}
	}
}

// MARK: Chart Private Helpers

private extension Chart {
	/// Computes Chart origin relative to PlotArea
	func getChartAreaOrigin(from frame: CGRect, chartShape: ChartShape) -> CGPoint? {
		if hasChartShape, chartShape.hasChartAreaBox {
			var origin = CGPoint.zero
			origin.x = frame.origin.x + CGFloat(chartShape.chartAreaBox.left.val + obj.plotArea.layout.left.val)
			origin.y = frame.origin.y + CGFloat(chartShape.chartAreaBox.top.val + obj.plotArea.layout.top.val)
			return origin
		}
		return nil
	}

	/// Draws Chart Background
	func drawBg(in ctx: RenderingContext, filling rect: CGRect, using config: PainterConfig?, forId id: String) {
		ctx.cgContext.saveGState()
		let path = CGPath(rect: rect, transform: nil)

		if hasProps, props.hasFill {
			ctx.cgContext.addPath(path)
			props.fill.draw(in: ctx, within: rect, using: config, forId: id)
		}
		if hasProps, props.hasStroke {
			props.stroke.draw(in: ctx, with: path, using: config, forId: id)
		}
		ctx.cgContext.restoreGState()
	}
}

// MARK: ChartShape + Draw

extension ChartShape {
	/// Draws ChartShape
	func draw(in ctx: RenderingContext, using config: PainterConfig?) {
		if hasPlotArea {
			plotArea.draw(in: ctx, using: config)
		}
		for legend in legends {
			legend.draw(in: ctx, withGroupProps: nil, using: config, matrix: .identity)
		}
		if hasTitle {
			title.draw(in: ctx, withGroupProps: nil, using: config, matrix: .identity)
		}
	}

	mutating func updateOrigin(_ positions: [Position]) {
		if plotArea.hasHorizontal {
			plotArea.horizontal.updateOrigin(positions)
		}
		if plotArea.hasVertical {
			plotArea.vertical.updateOrigin(positions)
		}
		for cIndex in 0..<plotArea.categoryShapes.count {
			plotArea.categoryShapes[cIndex].updateOrigin(positions)
		}
		for sIndex in 0..<plotArea.seriesLines.count {
			plotArea.seriesLines[sIndex].props.transform.pos.updateTo(positions)
		}
		for dIndex in 0..<plotArea.dropLines.count {
			plotArea.dropLines[dIndex].props.transform.pos.updateTo(positions)
		}
		for index in 0..<plotArea.upDownBars.count {
			plotArea.upDownBars[index].props.transform.pos.updateTo(positions)
		}
		for mIndex in 0..<plotArea.markers.count {
			plotArea.markers[mIndex].props.transform.pos.updateTo(positions)
		}
	}
}

// MARK: ChartShape.PlotAreaShape + Draw

extension ChartShape.PlotAreaShape {
	/// Draws Chart PlotArea
	func draw(in ctx: RenderingContext, using config: PainterConfig?) {
		if hasHorizontal {
			horizontal.draw(in: ctx, using: config) // Horizontal Axis
		}
		if hasVertical {
			vertical.draw(in: ctx, using: config) // Vertical Axis
		}
		for categoryShape in categoryShapes {
			categoryShape.drawShape(in: ctx, using: config)
		}
		for categoryShape in categoryShapes {
			categoryShape.drawLabel(in: ctx, using: config)
		}
		for line in seriesLines {
			line.draw(in: ctx, withGroupProps: nil, using: config, matrix: .identity)
		}
		for shape in upDownBars {
			shape.draw(in: ctx, withGroupProps: nil, using: config, matrix: .identity)
		}
		for line in dropLines {
			line.draw(in: ctx, withGroupProps: nil, using: config, matrix: .identity)
		}
		for marker in markers {
			marker.draw(in: ctx, withGroupProps: nil, using: config, matrix: .identity)
		}
	}
}

// MARK: ChartShape.AxisShape + Draw

extension ChartShape.AxisShape {
	/// Draws horizontal and vertical Chart Axes
	func draw(in ctx: RenderingContext, using config: PainterConfig?) {
		if hasTitle {
			title.draw(in: ctx, withGroupProps: nil, using: config, matrix: .identity)
		}
		if hasAxis {
			axis.draw(in: ctx, withGroupProps: nil, using: config, matrix: .identity)
		}
		for label in labels {
			label.draw(in: ctx, withGroupProps: nil, using: config, matrix: .identity)
		}
		for grid in majorGrids {
			grid.draw(in: ctx, withGroupProps: nil, using: config, matrix: .identity)
		}
		for grid in minorGrids {
			grid.draw(in: ctx, withGroupProps: nil, using: config, matrix: .identity)
		}
		for tick in majorTickMarks {
			tick.draw(in: ctx, withGroupProps: nil, using: config, matrix: .identity)
		}
		for tick in minorTickMarks {
			tick.draw(in: ctx, withGroupProps: nil, using: config, matrix: .identity)
		}
	}

	mutating func updateOrigin(_ positions: [Position]) {
		if hasTitle {
			title.props.transform.pos.updateTo(positions)
		}
		if hasAxis {
			axis.props.transform.pos.updateTo(positions)
		}
		for index in 0..<labels.count {
			labels[index].props.transform.pos.updateTo(positions)
		}
		for index in 0..<majorGrids.count {
			majorGrids[index].props.transform.pos.updateTo(positions)
		}
		for index in 0..<minorGrids.count {
			minorGrids[index].props.transform.pos.updateTo(positions)
		}
		for index in 0..<majorTickMarks.count {
			majorTickMarks[index].props.transform.pos.updateTo(positions)
		}
		for index in 0..<minorTickMarks.count {
			minorTickMarks[index].props.transform.pos.updateTo(positions)
		}
	}
}

// MARK: ChartShape.CategoryShape + Draw

extension ChartShape.CategoryShape {
	func drawShape(in ctx: RenderingContext, using config: PainterConfig?) {
		for seriesShape in seriesShapes where seriesShape.hasShape {
			seriesShape.shape.draw(in: ctx, withGroupProps: nil, using: config, matrix: .identity)
		}
	}

	func drawLabel(in ctx: RenderingContext, using config: PainterConfig?) {
		for seriesShape in seriesShapes where seriesShape.hasLabel {
			seriesShape.label.draw(in: ctx, withGroupProps: nil, using: config, matrix: .identity)
		}
	}

	/// Draws Chart Category Shapes
	func draw(in ctx: RenderingContext, using config: PainterConfig?) {
		for seriesShape in seriesShapes {
			if seriesShape.hasShape {
				seriesShape.shape.draw(in: ctx, withGroupProps: nil, using: config, matrix: .identity)
			}
			if seriesShape.hasLabel {
				seriesShape.label.draw(in: ctx, withGroupProps: nil, using: config, matrix: .identity)
			}
		}
	}

	mutating func updateOrigin(_ positions: [Position]) {
		for sIndex in 0..<seriesShapes.count {
			if seriesShapes[sIndex].hasShape {
				seriesShapes[sIndex].shape.props.transform.pos.updateTo(positions)
			}
			if seriesShapes[sIndex].hasLabel {
				seriesShapes[sIndex].label.props.transform.pos.updateTo(positions)
			}
		}
	}
}

extension Position {
	mutating func updateTo(_ positions: [Position]) {
		for position in positions {
			left += position.left
			top += position.top
		}
	}
}
