//
//  Table+Draw.swift
//  Painter
//
//  Created by Akshay T S on 06/11/17.
//  Copyright © 2017 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

// MARK: Table + Draw

extension Table {
	/// Draws entire Table
	func draw(in ctx: RenderingContext, within frame: CGRect, using config: PainterConfig?, forId id: String) {
		props.drawBg(in: ctx, within: frame, config: config, forId: id) // Draw Table Background

		var (x, y) = (frame.origin.x, frame.origin.y)
		let rowHeights = tableRowHeights(using: config)

		for (rowIndex, currentRow) in row.enumerated() {
			var rowHeight: CGFloat = 0

			for (cellIndex, currentCell) in currentRow.cell.enumerated() {
				var shouldDraw = true
				var cellWidth = CGFloat(grid.col[cellIndex].width)
				rowHeight = rowHeights[Int(rowIndex)]

				if currentCell.hasRow {
					if currentCell.row.hasSpan {
						rowHeight = getRowSpanHeight(rowIndex: rowIndex, cellIndex: cellIndex, rowHeights: rowHeights)
					}
					if currentCell.row.hasMerge, currentCell.row.merge == 1 {
						if currentCell.hasCol, currentCell.col.hasMerge, currentCell.col.merge == 1 {
							x -= CGFloat(grid.col[cellIndex].width)
						}
						shouldDraw = false
					}
				}
				if currentCell.hasCol {
					if currentCell.col.hasSpan {
						cellWidth = getColSpanWidth(cellIndex: cellIndex, colSpan: Int(currentCell.col.span))
					}
					if currentCell.col.hasMerge, currentCell.col.merge == 1 {
						x += cellWidth
						shouldDraw = false
					}
				}
				if shouldDraw {
					let cellFrame = CGRect(x: x, y: y, width: cellWidth, height: rowHeight)
					currentCell.draw(in: ctx, within: cellFrame, config: config, forId: id)
					x += cellWidth
				}
			}
			y += rowHeights[Int(rowIndex)]
			x = frame.origin.x
		}
	}

	func getHeightForTableFrame(using config: PainterConfig? = nil) -> [CGFloat] {
		if let height = config?.cache?.getTableRowHeightsMap(for: hashValue) {
			return height
		} else {
			let heightArray = getHeightsOfAllRows(using: config)
			config?.cache?.setTableRowHeightsMap(for: hashValue, value: heightArray)
			return heightArray
		}
	}

	func getWidthForTableFrame(using config: PainterConfig? = nil) -> [CGFloat] {
		if let width = config?.cache?.getTableColWidthsMap(for: hashValue) {
			return width
		} else {
			var colWidths = [CGFloat]()
			for col in self.grid.col {
				colWidths.append(CGFloat(col.width))
			}
			config?.cache?.setTableColWidthsMap(for: hashValue, value: colWidths)
			return colWidths
		}
	}
}

public extension Table {
	struct TableCellIndex: Equatable {
		public let rIndex: Int
		public let cIndex: Int

		public static let `default` = TableCellIndex(-1, -1)

		public init(_ rIndex: Int, _ cIndex: Int) {
			self.rIndex = rIndex
			self.cIndex = cIndex
		}
	}

	struct TableCellInfo: Equatable {
		public let frame: CGRect
		public let indices: TableCellIndex

		public static let `default` = TableCellInfo(
			frame: .zero,
			indices: .default)
	}

	func getTableHeight(using config: PainterConfig?) -> CGFloat {
		return self.getHeightForTableFrame(using: config).reduce(0, +)
	}

	func getTableWidth(using config: PainterConfig?) -> CGFloat {
		return self.getWidthForTableFrame(using: config).reduce(0, +)
	}

	func getTableHeights(using config: PainterConfig?) -> [CGFloat] {
		return self.getHeightForTableFrame(using: config)
	}

	func getTableCellsInfo(
		rect: CGRect,
		config: PainterConfig?) -> [TableCellInfo] {
		var tableCellsInfo = [TableCellInfo]()
		var (x, y) = (rect.origin.x, rect.origin.y)
		let rowHeights: [CGFloat] = tableRowHeights(using: config)

		for (rowIndex, currentRow) in self.row.enumerated() {
			var rowHeight: CGFloat = 0

			for (cellIndex, currentCell) in currentRow.cell.enumerated() {
				var shouldDraw = true
				var cellWidth = CGFloat(self.grid.col[cellIndex].width)
				rowHeight = rowHeights[Int(rowIndex)]

				if currentCell.hasRow {
					if currentCell.row.hasSpan {
						rowHeight = getRowSpanHeight(
							rowIndex: rowIndex,
							cellIndex: cellIndex,
							rowHeights: rowHeights)
					}
					if currentCell.row.hasMerge, currentCell.row.merge == 1 {
						if currentCell.hasCol,
						   currentCell.col.hasMerge,
						   currentCell.col.merge == 1 {
							x -= CGFloat(self.grid.col[cellIndex].width)
						}
						shouldDraw = false
					}
				}
				if currentCell.hasCol {
					if currentCell.col.hasSpan {
						cellWidth = getColSpanWidth(
							cellIndex: cellIndex,
							colSpan: Int(currentCell.col.span))
					}
					if currentCell.col.hasMerge, currentCell.col.merge == 1 {
						x += cellWidth
						shouldDraw = false
					}
				}
				if shouldDraw {
					let cellFrame = CGRect(x: x, y: y, width: cellWidth, height: rowHeight)
					let cellInfo = TableCellInfo(
						frame: cellFrame,
						indices: TableCellIndex(rowIndex, cellIndex))
					tableCellsInfo.append(cellInfo)
					x += cellWidth
				}
			}
			y += rowHeights[Int(rowIndex)]
			x = rect.origin.x
		}
		return tableCellsInfo
	}
}

// MARK: Private Helpers

private extension Table {
	/// Computes total height of the table including the contents of each cell
	func tableRowHeights(using config: PainterConfig?) -> [CGFloat] {
		var rowHeights: [CGFloat]
		if let heights = config?.cache?.getTableRowHeightsMap(for: hashValue) {
			rowHeights = heights
		} else {
			rowHeights = self.getHeightsOfAllRows(using: config)
			config?.cache?.setTableRowHeightsMap(for: hashValue, value: rowHeights)
		}
		return rowHeights
	}

	/// Computes height of merged cells in a column
	func getRowSpanHeight(
		rowIndex: Int,
		cellIndex: Int,
		rowHeights: [CGFloat]) -> CGFloat {
		let currentRow = row[rowIndex]
		let currentCell = currentRow.cell[cellIndex]
		var height = rowHeights[rowIndex]

		for i in 1..<currentCell.row.span {
			let index = Int(rowIndex) + Int(i)
			if index > rowHeights.count {
				break
			}
			height += rowHeights[index]
		}
		return height
	}

	/// Computes width of merged cells in a row
	func getColSpanWidth(cellIndex: Int, colSpan: Int) -> CGFloat {
		var width = CGFloat(grid.col[cellIndex].width)

		for i in 1..<colSpan {
			let index = cellIndex + i
			if index > grid.col.count {
				break
			}
			width += CGFloat(grid.col[index].width)
		}
		return width
	}

	/// Computes the height of all rows in a table
	func getHeightsOfAllRows(using config: PainterConfig? = nil) -> [CGFloat] {
		var rowHeights = [CGFloat]()

		for rowIndex in 0..<row.count {
			let currentRow = row[rowIndex]
			var height = CGFloat(currentRow.height)

			for cellIndex in 0..<currentRow.cell.count {
				let currentCell = currentRow.cell[cellIndex]
				var width = CGFloat(grid.col[cellIndex].width)

				if currentCell.hasCol, currentCell.col.hasSpan {
					width = self.getColSpanWidth(
						cellIndex: cellIndex,
						colSpan: Int(currentCell.col.span))
				}
				if currentCell.hasRow, currentCell.row.hasSpan {
					continue
				}

				let cellFrame = CGRect(
					origin: .zero,
					size: CGSize(width: width, height: height))
				let textFrame = currentCell.textBody.getTextBoxFrame(
					enclosedBy: cellFrame,
					forId: currentCell.id,
					using: config)

				if textFrame.size.height > height {
					height = textFrame.size.height
				}
			}
			rowHeights.insert(height, at: Int(rowIndex))
		}
		self.getActualHeightOfRows(computedHeights: &rowHeights, using: config)
		return rowHeights
	}

	/// Computes actual height of table rows that includes text inside each cell
	func getActualHeightOfRows(
		computedHeights rowHeights: inout [CGFloat],
		using config: PainterConfig? = nil) {
		for rowIndex in 0..<row.count {
			var height = CGFloat()
			let currentRow = row[rowIndex]

			for cellIndex in 0..<currentRow.cell.count {
				let currentCell = currentRow.cell[cellIndex]
				var width = CGFloat(grid.col[cellIndex].width)

				if currentCell.hasCol, currentCell.col.hasSpan {
					width = self.getColSpanWidth(
						cellIndex: cellIndex,
						colSpan: Int(currentCell.col.span))
				}

				height = rowHeights[rowIndex]
				if currentCell.hasRow, currentCell.row.hasSpan {
					height = self.getRowSpanHeight(
						rowIndex: rowIndex,
						cellIndex: cellIndex,
						rowHeights: rowHeights)

					let cellFrame = CGRect(
						origin: .zero,
						size: CGSize(width: width, height: height))
					let textFrame = currentCell.textBody.getTextBoxFrame(
						enclosedBy: cellFrame,
						forId: currentCell.id,
						using: config)

					if textFrame.size.height > height {
						let previousHeight = rowHeights.remove(at: Int(rowIndex) + Int(currentCell.row.span - 1))
						let currentHeight = previousHeight + (textFrame.size.height - height)
						rowHeights.insert(currentHeight, at: Int(rowIndex) + Int(currentCell.row.span - 1))
					}
				}
			}
		}
	}
}

// MARK: TableProperties + Draw

private extension Table.TableProperties {
	/// Draws Table Background
	func drawBg(in ctx: RenderingContext, within frame: CGRect, config: PainterConfig?, forId id: String) {
		if hasFill {
			ctx.cgContext.saveGState()
			ctx.cgContext.addPath(CGPath(rect: frame, transform: nil))
			fill.draw(in: ctx, within: frame, using: config, forId: id)
			ctx.cgContext.restoreGState()
		}
	}
}

// MARK: TableCell + Draw

private extension Table.TableRow.TableCell {
	/// Draws Table Cell
	func draw(in ctx: RenderingContext, within frame: CGRect, config: PainterConfig?, forId id: String) {
		if hasProps, props.hasStyle, props.style.hasFill, !props.style.fill.isEmpty { // Fill color in Table Cell
			ctx.cgContext.saveGState()
			ctx.cgContext.addPath(CGPath(rect: frame, transform: nil))
			props.style.fill.draw(in: ctx, within: frame, using: config, forId: self.id)
			ctx.cgContext.restoreGState()
		}
		if hasProps, props.hasStyle, props.style.hasBorders { // Draw Table Cell Borders
			props.style.borders.draw(in: ctx, within: frame, using: config, forId: self.id)
		}
		if hasTextBody, ctx.editingTextID != self.id {
			textBody.draw(inside: frame, forId: self.id, using: config) // Draw contents in a Table Cell
		}
	}
}

// MARK: TableCellBorders + Draw

extension TableCellBorders {
	/// Draws Table Cell Border
	func draw(in ctx: RenderingContext, within frame: CGRect, using config: PainterConfig?, forId id: String) {
		if hasLeft {
			let leftBorder = CGPath(
				rect: CGRect(x: frame.origin.x, y: frame.origin.y, width: 0, height: frame.height),
				transform: nil)
			left.border.draw(in: ctx, with: leftBorder, using: config, forId: id)
		}
		if hasTop {
			let topBorder = CGPath(
				rect: CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: 0),
				transform: nil)
			top.border.draw(in: ctx, with: topBorder, using: config, forId: id)
		}
		if hasRight {
			let rightBorder = CGPath(
				rect: CGRect(x: frame.origin.x + frame.width, y: frame.origin.y, width: 0, height: frame.height),
				transform: nil)
			right.border.draw(in: ctx, with: rightBorder, using: config, forId: id)
		}
		if hasBottom {
			let bottomBorder = CGPath(
				rect: CGRect(x: frame.origin.x, y: frame.origin.y + frame.height, width: frame.width, height: 0),
				transform: nil)
			bottom.border.draw(in: ctx, with: bottomBorder, using: config, forId: id)
		}
	}
}
