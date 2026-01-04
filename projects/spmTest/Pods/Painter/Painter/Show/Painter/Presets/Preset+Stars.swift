//
//  Preset+Stars.swift
//  Painter
//
//  Created by Sarath Kumar G on 18/04/18.
//  Copyright © 2018 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

// swiftlint:disable file_length function_body_length
extension Preset {
	func explosion1(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let midX: CGFloat = w * 0.5
		let val: CGFloat = 21_600.0
		let tx: CGFloat = w / val
		let ty: CGFloat = h / val
		let x1: CGFloat = 4_627.0 * tx
		let y1: CGFloat = 6_320.0 * ty
		let x2: CGFloat = 16_702.0 * tx
		let y2: CGFloat = 13_937.0 * ty
		let y3: CGFloat = 13_290.0 * ty
		let x3: CGFloat = 8_485.0 * tx
		let y4: CGFloat = 8_615.0 * ty
		let x4: CGFloat = 14_522.0 * tx

		let path = CGMutablePath()
		path.move(to: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + 5_800.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y)))
		path.addLine(to: CGPoint(x: CGFloat(x + 14_155.0 * tx), y: CGFloat(y + 5_325.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + 18_380.0 * tx), y: CGFloat(y + 4_457.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + 7_315.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + 21_097.0 * tx), y: CGFloat(y + 8_137.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + 17_607.0 * tx), y: CGFloat(y + 10_475.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + y3)))
		path.addLine(to: CGPoint(x: CGFloat(x + 16_837.0 * tx), y: CGFloat(y + 12_942.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + 18_145.0 * tx), y: CGFloat(y + 18_095.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + 14_020.0 * tx), y: CGFloat(y + 14_457.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + 13_247.0 * tx), y: CGFloat(y + 19_737.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + 10_532.0 * tx), y: CGFloat(y + 14_935.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + h)))
		path.addLine(to: CGPoint(x: CGFloat(x + 7_715.0 * tx), y: CGFloat(y + 15_627.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + 4_762.0 * tx), y: CGFloat(y + 17_617.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + 5_667.0 * tx), y: CGFloat(y + y2)))
		path.addLine(to: CGPoint(x: CGFloat(x + 135.0 * tx), y: CGFloat(y + 14_587.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + 3_722.0 * tx), y: CGFloat(y + 11_775.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + y4)))
		path.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + 7_617.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + 370.0 * tx), y: CGFloat(y + 2_295.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + 7_312.0 * tx), y: CGFloat(y + y1)))
		path.addLine(to: CGPoint(x: CGFloat(x + 8_352.0 * tx), y: CGFloat(y + 2_295.0 * ty)))
		path.closeSubpath()

		let textFrame = CGRect(x: x + x1, y: y + y1, width: x2 - x1, height: y2 - y1)
		let animationFrame = frame
		let connector = [[x4, 0, 270], [0, y4, 180], [x3, h, 90], [w, y3, 0]]
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func explosion2(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let val: CGFloat = 21_600.0
		let tx: CGFloat = w / val
		let ty: CGFloat = h / val
		let x1: CGFloat = 5_372.0 * tx
		let y1: CGFloat = 6_382.0 * ty
		let x2: CGFloat = 14_640.0 * tx
		let y2: CGFloat = 15_935.0 * ty
		let x3: CGFloat = 9_722.0 * tx
		let y3: CGFloat = 1_887.0 * ty
		let y4: CGFloat = 12_877.0 * ty
		let x5: CGFloat = 11_612.0 * tx
		let y5: CGFloat = 18_842.0 * ty
		let y6: CGFloat = 6_645.0 * ty

		let path = CGMutablePath()
		path.move(to: CGPoint(x: CGFloat(x + 11_462.0 * tx), y: CGFloat(y + 4_342.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + 14_790 * tx), y: CGFloat(y)))
		path.addLine(to: CGPoint(x: CGFloat(x + 14_525.0 * tx), y: CGFloat(y + 5_777.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + 18_007.0 * tx), y: CGFloat(y + 3_172.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + 16_380.0 * tx), y: CGFloat(y + 6_532.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + y6)))
		path.addLine(to: CGPoint(x: CGFloat(x + 16_985.0 * tx), y: CGFloat(y + 9_402.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + 18_270.0 * tx), y: CGFloat(y + 11_290.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + 16_380.0 * tx), y: CGFloat(y + 12_310.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + 18_877.0 * tx), y: CGFloat(y + 15_632.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + 14_350.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + 14_942.0 * tx), y: CGFloat(y + 17_370.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + 12_180.0 * tx), y: CGFloat(y + y2)))
		path.addLine(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y5)))
		path.addLine(to: CGPoint(x: CGFloat(x + 9_872.0 * tx), y: CGFloat(y + 17_370.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + 8_700.0 * tx), y: CGFloat(y + 19_712 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + 7_527.0 * tx), y: CGFloat(y + 18_125.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + 4_917.0 * tx), y: CGFloat(y + h)))
		path.addLine(to: CGPoint(x: CGFloat(x + 4_805.0 * tx), y: CGFloat(y + 18_240.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + 1_285.0 * tx), y: CGFloat(y + 17_825.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + 3_330.0 * tx), y: CGFloat(y + 15_370.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + y4)))
		path.addLine(to: CGPoint(x: CGFloat(x + 3_935.0 * tx), y: CGFloat(y + 11_592.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + 1_172.0 * tx), y: CGFloat(y + 8_270.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + 7_817.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + 4_502.0 * tx), y: CGFloat(y + 3_625.0 * ty)))
		path.addLine(to: CGPoint(x: CGFloat(x + 8_550.0 * tx), y: CGFloat(y + y1)))
		path.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y3)))
		path.closeSubpath()

		let textFrame = CGRect(x: x + x1, y: y + y1, width: x2 - x1, height: y2 - y1)
		let animationFrame = frame
		let connector = [[x3, y3, 270], [0, y4, 180], [x5, y5, 90], [w, y6, 0]]
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func fourPointStar(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let a1: CGFloat = modifiers[0]
		let midX: CGFloat = w * 0.5
		let midY: CGFloat = h * 0.5
		let x1: CGFloat = w * a1
		let y1: CGFloat = h * a1
		let x2: CGFloat = x1 * CGFloat(cosf(Float.pi / 4))
		let y2: CGFloat = y1 * CGFloat(sinf(Float.pi / 4))
		let x3: CGFloat = midX - x2
		let x4: CGFloat = midX + x2
		let y3: CGFloat = midY - y2
		let y4: CGFloat = midY + y2
		let yVal: CGFloat = midY - y1

		let path = CGMutablePath()
		path.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y + midY)))
		path.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y3)))
		path.addLine(to: CGPoint(x: CGFloat(x + midX), y: CGFloat(y)))
		path.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y3)))
		path.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + midY)))
		path.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y4)))
		path.addLine(to: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + h)))
		path.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y4)))
		path.closeSubpath()

		let handles = [CGPoint(midX, yVal)]
		let textFrame = CGRect(x: x + x3, y: y + y3, width: x4 - x3, height: y4 - y3)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func fivePointStar(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let val1: CGFloat = 1.051_46
		let midX: CGFloat = w * 0.5
		let midY: CGFloat = h * 0.5
		let a: CGFloat = modifiers[0]
		let a1: CGFloat = midX * val1
		let dx1: CGFloat = a1 * CGFloat(cosf(Float(18.0 / 180.0) * Float.pi))
		let dx2: CGFloat = a1 * CGFloat(cosf(Float(306.0 / 180.0) * Float.pi))
		let dy1: CGFloat = midY * CGFloat(sinf(Float(18.0 / 180.0) * Float.pi))
		let dy2: CGFloat = midY * CGFloat(sinf(Float(306.0 / 180.0) * Float.pi))
		let x1: CGFloat = midX - dx1
		let x2: CGFloat = midX - dx2
		let x3: CGFloat = midX + dx2
		let x4: CGFloat = midX + dx1
		let y1: CGFloat = midY - dy1
		let y2: CGFloat = midY - dy2
		let a3: CGFloat = (a1 * a) * 2
		let a4: CGFloat = (midY * a) * 2
		let sdx1: CGFloat = a3 * CGFloat(cosf(Float(342.0 / 180.0) * Float.pi))
		let sdx2: CGFloat = a3 * CGFloat(cosf(Float(54.0 / 180.0) * Float.pi))
		let sdy1: CGFloat = a4 * CGFloat(sinf(Float(54.0 / 180.0) * Float.pi))
		let sdy2: CGFloat = a4 * CGFloat(sinf(Float(342.0 / 180.0) * Float.pi))
		let sx1: CGFloat = midX - sdx1
		let sx2: CGFloat = midX - sdx2
		let sx3: CGFloat = midX + sdx2
		let sx4: CGFloat = midX + sdx1
		let sy1: CGFloat = midY - sdy1
		let sy2: CGFloat = midY - sdy2
		let sy3: CGFloat = midY + a4
		let yVal: CGFloat = midY - a4

		let path = CGMutablePath()
		path.move(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y1)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx2), y: CGFloat(y + sy1)))
		path.addLine(to: CGPoint(x: CGFloat(x + midX), y: CGFloat(y)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx3), y: CGFloat(y + sy1)))
		path.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y1)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx4), y: CGFloat(y + sy2)))
		path.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y2)))
		path.addLine(to: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + sy3)))
		path.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y2)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx1), y: CGFloat(y + sy2)))
		path.closeSubpath()

		let handles = [CGPoint(midX, yVal)]
		let textFrame = CGRect(x: x + sx1, y: y + sy1, width: sx4 - sx1, height: sy3 - sy1)
		let animationFrame = frame
		let connector = [[midX, 0, 270], [x1, y1, 180], [x2, y2, 90], [x3, y2, 90], [x4, y1, 0]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func sixPointStar(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let a: CGFloat = modifiers[0]
		let midX: CGFloat = w * 0.5
		let midY: CGFloat = h * 0.5
		let dx1: CGFloat = midX * CGFloat(cosf((30.0 / 180.0) * .pi))
		let x1: CGFloat = midX - dx1
		let x2: CGFloat = midX + dx1
		let h4: CGFloat = h * 0.25
		let y2: CGFloat = midY + h4
		let a1: CGFloat = w * a
		let a2: CGFloat = h * a
		let a3: CGFloat = a1 * 0.5
		let sx1: CGFloat = midX - a1
		let sx2: CGFloat = midX - a3
		let sx3: CGFloat = midX + a3
		let sx4: CGFloat = midX + a1
		let a4: CGFloat = a2 * CGFloat(sinf((60.0 / 180.0) * .pi))
		let sy1: CGFloat = midY - a4
		let sy2: CGFloat = midY + a4
		let yVal: CGFloat = midY - a2

		let path = CGMutablePath()
		path.move(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + h4)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx2), y: CGFloat(y + sy1)))
		path.addLine(to: CGPoint(x: CGFloat(x + midX), y: CGFloat(y)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx3), y: CGFloat(y + sy1)))
		path.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + h4)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx4), y: CGFloat(y + midY)))
		path.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y2)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx3), y: CGFloat(y + sy2)))
		path.addLine(to: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + h)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx2), y: CGFloat(y + sy2)))
		path.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y2)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx1), y: CGFloat(y + midY)))
		path.closeSubpath()

		let handles = [CGPoint(midX, yVal)]
		let textFrame = CGRect(x: x + sx1, y: y + sy1, width: sx4 - sx1, height: sy2 - sy1)
		let animationFrame = frame
		let connector = [[x2, h4, 0], [x2, y2, 0], [midX, h, 90], [x1, y2, 180], [x1, h4, 180], [midX, 0, 270]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func sevenPointStar(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let a: CGFloat = modifiers[0]
		let midX: CGFloat = w * 0.5
		let midY: CGFloat = h * 0.5
		let val1: CGFloat = 0.974_93
		let val2: CGFloat = 0.781_83
		let val3: CGFloat = 0.433_88
		let val4: CGFloat = 0.623_49
		let val5: CGFloat = 0.222_52
		let val6: CGFloat = 0.900_97
		let dx1: CGFloat = midX * val1
		let dx2: CGFloat = midX * val2
		let dx3: CGFloat = midX * val3
		let dy1: CGFloat = midY * val4
		let dy2: CGFloat = midY * val5
		let dy3: CGFloat = midY * val6
		let x1: CGFloat = midX - dx1
		let x2: CGFloat = midX - dx2
		let x3: CGFloat = midX - dx3
		let x4: CGFloat = midX + dx3
		let x5: CGFloat = midX + dx2
		let x6: CGFloat = midX + dx1
		let y1: CGFloat = midY - dy1
		let y2: CGFloat = midY + dy2
		let y3: CGFloat = midY + dy3
		let a1: CGFloat = w * a
		let a2: CGFloat = h * a
		let sdx1: CGFloat = a1 * val1
		let sdx2: CGFloat = a1 * val2
		let sdx3: CGFloat = a1 * val3
		let sx1: CGFloat = midX - sdx1
		let sx2: CGFloat = midX - sdx2
		let sx3: CGFloat = midX - sdx3
		let sx4: CGFloat = midX + sdx3
		let sx5: CGFloat = midX + sdx2
		let sx6: CGFloat = midX + sdx1
		let sdy1: CGFloat = a2 * val6
		let sdy2: CGFloat = a2 * val5
		let sdy3: CGFloat = a2 * val4
		let sy1: CGFloat = midY - sdy1
		let sy2: CGFloat = midY - sdy2
		let sy3: CGFloat = midY + sdy3
		let sy4: CGFloat = midY + a2
		let yVal: CGFloat = midY - a2

		let path = CGMutablePath()
		path.move(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y2)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx1), y: CGFloat(y + sy2)))
		path.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y1)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx3), y: CGFloat(y + sy1)))
		path.addLine(to: CGPoint(x: CGFloat(x + midX), y: CGFloat(y)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx4), y: CGFloat(y + sy1)))
		path.addLine(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y1)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx6), y: CGFloat(y + sy2)))
		path.addLine(to: CGPoint(x: CGFloat(x + x6), y: CGFloat(y + y2)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx5), y: CGFloat(y + sy3)))
		path.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y3)))
		path.addLine(to: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + sy4)))
		path.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y3)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx2), y: CGFloat(y + sy3)))
		path.closeSubpath()

		let handles = [CGPoint(midX, yVal)]
		let textFrame = CGRect(x: x + sx2, y: y + sy1, width: sx5 - sx2, height: sy3 - sy1)
		let animationFrame = frame
		let connector = [[x5, y1, 0], [x6, y2, 0], [x4, y3, 90], [x3, y3, 90], [x1, y2, 180], [x2, y1, 180], [midX, 0, 270]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func eightPointStar(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let path = CGMutablePath()
		let a: CGFloat = modifiers[0]

		let midX: CGFloat = w * 0.5
		let midY: CGFloat = h * 0.5
		let dx1: CGFloat = midX * CGFloat(cosf(.pi / 4))
		let x1: CGFloat = midX - dx1
		let x2: CGFloat = midX + dx1
		let dy1: CGFloat = midY * CGFloat(sinf(.pi / 4))
		let y1: CGFloat = midY - dy1
		let y2: CGFloat = midY + dy1
		let a1: CGFloat = w * a
		let a2: CGFloat = h * a
		let val1: CGFloat = 0.923_88
		let val2: CGFloat = 0.382_68
		let sdx1: CGFloat = a1 * val1
		let sdx2: CGFloat = a1 * val2
		let sdy1: CGFloat = a2 * val1
		let sdy2: CGFloat = a2 * val2
		let sx1: CGFloat = midX - sdx1
		let sx2: CGFloat = midX - sdx2
		let sx3: CGFloat = midX + sdx2
		let sx4: CGFloat = midX + sdx1
		let sy1: CGFloat = midY - sdy1
		let sy2: CGFloat = midY - sdy2
		let sy3: CGFloat = midY + sdy2
		let sy4: CGFloat = midY + sdy1
		let yVal: CGFloat = midY - a2

		path.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y + midY)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx1), y: CGFloat(y + sy2)))
		path.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y1)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx2), y: CGFloat(y + sy1)))
		path.addLine(to: CGPoint(x: CGFloat(x + midX), y: CGFloat(y)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx3), y: CGFloat(y + sy1)))
		path.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y1)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx4), y: CGFloat(y + sy2)))
		path.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + midY)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx4), y: CGFloat(y + sy3)))
		path.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y2)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx3), y: CGFloat(y + sy4)))
		path.addLine(to: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + h)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx2), y: CGFloat(y + sy4)))
		path.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y2)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx1), y: CGFloat(y + sy3)))
		path.closeSubpath()

		let handles = [CGPoint(midX, yVal)]
		let textFrame = CGRect(x: x + sx1, y: y + sy1, width: sx4 - sx1, height: sy4 - sy1)
		let animationFrame = frame
		let connector = [[w, midY, 0], [x2, y2, 90], [midX, h, 90], [x1, y2, 90], [0, midY, 180], [x1, y1, 270], [midX, 0, 270], [x2, y1, 270]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func tenPointStar(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let a: CGFloat = modifiers[0]

		let midX: CGFloat = w * 0.5
		let midY: CGFloat = h * 0.5
		let val1: CGFloat = 0.951_06
		let val2: CGFloat = 0.587_79
		let dx1: CGFloat = midX * val1
		let dx2: CGFloat = midX * val2
		let x1: CGFloat = midX - dx1
		let x2: CGFloat = midX - dx2
		let x3: CGFloat = midX + dx2
		let x4: CGFloat = midX + dx1
		let val3: CGFloat = 0.809_02
		let val4: CGFloat = 0.309_02
		let dy1: CGFloat = midY * val3
		let dy2: CGFloat = midY * val4
		let y1: CGFloat = midY - dy1
		let y2: CGFloat = midY - dy2
		let y3: CGFloat = midY + dy2
		let y4: CGFloat = midY + dy1
		let a1: CGFloat = w * a
		let a2: CGFloat = h * a
		let sdx1: CGFloat = val3 * a1
		let sdx2: CGFloat = val4 * a1
		let sdy1: CGFloat = val1 * a2
		let sdy2: CGFloat = val2 * a2
		let sx1: CGFloat = midX - a1
		let sx2: CGFloat = midX - sdx1
		let sx3: CGFloat = midX - sdx2
		let sx4: CGFloat = midX + sdx2
		let sx5: CGFloat = midX + sdx1
		let sx6: CGFloat = midX + a1
		let sy1: CGFloat = midY - sdy1
		let sy2: CGFloat = midY - sdy2
		let sy3: CGFloat = midY + sdy2
		let sy4: CGFloat = midY + sdy1
		let yVal: CGFloat = midY - a2

		let path = CGMutablePath()
		path.move(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y2)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx2), y: CGFloat(y + sy2)))
		path.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y1)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx3), y: CGFloat(y + sy1)))
		path.addLine(to: CGPoint(x: CGFloat(x + midX), y: CGFloat(y)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx4), y: CGFloat(y + sy1)))
		path.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y1)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx5), y: CGFloat(y + sy2)))
		path.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y2)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx6), y: CGFloat(y + midY)))
		path.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y3)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx5), y: CGFloat(y + sy3)))
		path.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y4)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx4), y: CGFloat(y + sy4)))
		path.addLine(to: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + h)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx3), y: CGFloat(y + sy4)))
		path.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y4)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx2), y: CGFloat(y + sy3)))
		path.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y3)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx1), y: CGFloat(y + midY)))
		path.closeSubpath()

		let handles = [CGPoint(midX, yVal)]
		let textFrame = CGRect(x: x + sx2, y: y + sy2, width: sx5 - sx2, height: sy3 - sy2)
		let animationFrame = frame
		let connector = [[x4, y2, 0], [x4, y3, 0], [x3, y4, 90], [midX, h, 90], [x2, y4, 90], [x1, y3, 180], [x1, y2, 180], [x2, y1, 270], [midX, 0, 270], [x3, y1, 270]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func twelvePointStar(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let a: CGFloat = modifiers[0]

		let midX: CGFloat = w * 0.5
		let midY: CGFloat = h * 0.5

		let dx1: CGFloat = midX * CGFloat(cosf((30.0 / 180.0) * .pi))
		let dy1: CGFloat = midY * CGFloat(sinf((60.0 / 180.0) * .pi))
		let x1: CGFloat = midX - dx1
		let x3: CGFloat = w * 0.75
		let x4: CGFloat = midX + dx1
		let y1: CGFloat = midY - dy1
		let y3: CGFloat = h * 0.75
		let y4: CGFloat = midY + dy1
		let a1: CGFloat = w * a
		let a2: CGFloat = h * a
		let sdx1: CGFloat = a1 * CGFloat(cosf((15.0 / 180.0) * .pi))
		let sdx2: CGFloat = a1 * CGFloat(cosf((45.0 / 180.0) * .pi))
		let sdx3: CGFloat = a1 * CGFloat(cosf((75.0 / 180.0) * .pi))
		let sdy1: CGFloat = a2 * CGFloat(sinf((75.0 / 180.0) * .pi))
		let sdy2: CGFloat = a2 * CGFloat(sinf((45.0 / 180.0) * .pi))
		let sdy3: CGFloat = a2 * CGFloat(sinf((15.0 / 180.0) * .pi))
		let sx1: CGFloat = midX - sdx1
		let sx2: CGFloat = midX - sdx2
		let sx3: CGFloat = midX - sdx3
		let sx4: CGFloat = midX + sdx3
		let sx5: CGFloat = midX + sdx2
		let sx6: CGFloat = midX + sdx1
		let sy1: CGFloat = midY - sdy1
		let sy2: CGFloat = midY - sdy2
		let sy3: CGFloat = midY - sdy3
		let sy4: CGFloat = midY + sdy3
		let sy5: CGFloat = midY + sdy2
		let sy6: CGFloat = midY + sdy1
		let h4: CGFloat = h * 0.25
		let w4: CGFloat = w * 0.25
		let yVal: CGFloat = midY - a2

		let path = CGMutablePath()
		path.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y + midY)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx1), y: CGFloat(y + sy3)))
		path.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + h4)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx2), y: CGFloat(y + sy2)))
		path.addLine(to: CGPoint(x: CGFloat(x + w4), y: CGFloat(y + y1)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx3), y: CGFloat(y + sy1)))
		path.addLine(to: CGPoint(x: CGFloat(x + midX), y: CGFloat(y)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx4), y: CGFloat(y + sy1)))
		path.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y1)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx5), y: CGFloat(y + sy2)))
		path.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + h4)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx6), y: CGFloat(y + sy3)))
		path.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + midY)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx6), y: CGFloat(y + sy4)))
		path.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y3)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx5), y: CGFloat(y + sy5)))
		path.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y4)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx4), y: CGFloat(y + sy6)))
		path.addLine(to: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + h)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx3), y: CGFloat(y + sy6)))
		path.addLine(to: CGPoint(x: CGFloat(x + w4), y: CGFloat(y + y4)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx2), y: CGFloat(y + sy5)))
		path.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y3)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx1), y: CGFloat(y + sy4)))
		path.closeSubpath()

		let handles = [CGPoint(midX, yVal)]
		let textFrame = CGRect(x: x + sx2, y: y + sy2, width: sx5 - sx2, height: sy5 - sy2)
		let animationFrame = frame
		let connector = [[x4, h4, 0], [w, midY, 0], [x4, y3, 0], [x3, y4, 90], [midX, h, 90], [w4, y4, 90], [x1, y3, 180], [0, midY, 180], [x1, h4, 180], [w4, y1, 270], [midX, 0, 270], [x3, y1, 270]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func sixteenPointStar(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let a: CGFloat = modifiers[0]

		let midX: CGFloat = w * 0.5
		let midY: CGFloat = h * 0.5

		let val1: CGFloat = 0.923_88
		let val2: CGFloat = 0.707_11
		let val3: CGFloat = 0.382_68
		let dx1: CGFloat = midX * val1
		let dx2: CGFloat = midX * val2
		let dx3: CGFloat = midX * val3
		let dy1: CGFloat = midY * val1
		let dy2: CGFloat = midY * val2
		let dy3: CGFloat = midY * val3
		let x1: CGFloat = midX - dx1
		let x2: CGFloat = midX - dx2
		let x3: CGFloat = midX - dx3
		let x4: CGFloat = midX + dx3
		let x5: CGFloat = midX + dx2
		let x6: CGFloat = midX + dx1
		let y1: CGFloat = midY - dy1
		let y2: CGFloat = midY - dy2
		let y3: CGFloat = midY - dy3
		let y4: CGFloat = midY + dy3
		let y5: CGFloat = midY + dy2
		let y6: CGFloat = midY + dy1
		let a1: CGFloat = w * a
		let a2: CGFloat = h * a
		let val4: CGFloat = 0.980_79
		let val5: CGFloat = 0.831_47
		let val6: CGFloat = 0.555_57
		let val7: CGFloat = 0.195_09
		let sdx1: CGFloat = a1 * val4
		let sdx2: CGFloat = a1 * val5
		let sdx3: CGFloat = a1 * val6
		let sdx4: CGFloat = a1 * val7
		let sdy1: CGFloat = a2 * val4
		let sdy2: CGFloat = a2 * val5
		let sdy3: CGFloat = a2 * val6
		let sdy4: CGFloat = a2 * val7
		let sx1: CGFloat = midX - sdx1
		let sx2: CGFloat = midX - sdx2
		let sx3: CGFloat = midX - sdx3
		let sx4: CGFloat = midX - sdx4
		let sx5: CGFloat = midX + sdx4
		let sx6: CGFloat = midX + sdx3
		let sx7: CGFloat = midX + sdx2
		let sx8: CGFloat = midX + sdx1
		let sy1: CGFloat = midY - sdy1
		let sy2: CGFloat = midY - sdy2
		let sy3: CGFloat = midY - sdy3
		let sy4: CGFloat = midY - sdy4
		let sy5: CGFloat = midY + sdy4
		let sy6: CGFloat = midY + sdy3
		let sy7: CGFloat = midY + sdy2
		let sy8: CGFloat = midY + sdy1
		let yVal: CGFloat = midY - a2

		let path = CGMutablePath()
		path.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y + midY)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx1), y: CGFloat(y + sy4)))
		path.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y3)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx2), y: CGFloat(y + sy3)))
		path.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y2)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx3), y: CGFloat(y + sy2)))
		path.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y1)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx4), y: CGFloat(y + sy1)))
		path.addLine(to: CGPoint(x: CGFloat(x + midX), y: CGFloat(y)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx5), y: CGFloat(y + sy1)))
		path.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y1)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx6), y: CGFloat(y + sy2)))
		path.addLine(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y2)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx7), y: CGFloat(y + sy3)))
		path.addLine(to: CGPoint(x: CGFloat(x + x6), y: CGFloat(y + y3)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx8), y: CGFloat(y + sy4)))
		path.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + midY)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx8), y: CGFloat(y + sy5)))
		path.addLine(to: CGPoint(x: CGFloat(x + x6), y: CGFloat(y + y4)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx7), y: CGFloat(y + sy6)))
		path.addLine(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y5)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx6), y: CGFloat(y + sy7)))
		path.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y6)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx5), y: CGFloat(y + sy8)))
		path.addLine(to: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + h)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx4), y: CGFloat(y + sy8)))
		path.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y6)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx3), y: CGFloat(y + sy7)))
		path.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y5)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx2), y: CGFloat(y + sy6)))
		path.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y4)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx1), y: CGFloat(y + sy5)))
		path.closeSubpath()

		let ang: CGFloat = ((.pi * 45) / 180)
		let ix: CGFloat = a1 * cos(ang)
		let iy: CGFloat = a2 * sin(ang)
		let l: CGFloat = midX - ix
		let t: CGFloat = midY - iy
		let r: CGFloat = midX + ix
		let b: CGFloat = midY + iy

		let handles = [CGPoint(midX, yVal)]
		let textFrame = CGRect(x: x + l, y: y + t, width: r - l, height: b - t)
		let animationFrame = frame
		let connector = [[x5, y2, 0], [x6, y3, 0], [w, midY, 0], [x6, y4, 0], [x5, y5, 0], [x4, y6, 90], [midX, h, 90], [x3, y6, 90], [x2, y5, 180], [x1, y4, 180], [0, midY, 180], [x1, y3, 180], [x2, y2, 180], [x3, y1, 270], [midX, 0, 270], [x4, y1, 270]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func twentyFourPointStar(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let a: CGFloat = modifiers[0]
		let midX: CGFloat = w * 0.5
		let midY: CGFloat = h * 0.5

		let dx1: CGFloat = midX * CGFloat(cosf((15.0 / 180.0) * .pi))
		let dx2: CGFloat = midX * CGFloat(cosf((30.0 / 180.0) * .pi))
		let dx3: CGFloat = midX * CGFloat(cosf((45.0 / 180.0) * .pi))
		let dx4: CGFloat = w * 0.25
		let dx5: CGFloat = midX * CGFloat(cosf((75.0 / 180.0) * .pi))
		let dy1: CGFloat = midY * CGFloat(sinf((75.0 / 180.0) * .pi))
		let dy2: CGFloat = midY * CGFloat(sinf((60.0 / 180.0) * .pi))
		let dy3: CGFloat = midY * CGFloat(sinf((45.0 / 180.0) * .pi))
		let dy4: CGFloat = h * 0.25
		let dy5: CGFloat = midY * CGFloat(sinf((15.0 / 180.0) * .pi))
		let x1: CGFloat = midX - dx1
		let x2: CGFloat = midX - dx2
		let x3: CGFloat = midX - dx3
		let x4: CGFloat = midX - dx4
		let x5: CGFloat = midX - dx5
		let x6: CGFloat = midX + dx5
		let x7: CGFloat = midX + dx4
		let x8: CGFloat = midX + dx3
		let x9: CGFloat = midX + dx2
		let x10: CGFloat = midX + dx1
		let y1: CGFloat = midY - dy1
		let y2: CGFloat = midY - dy2
		let y3: CGFloat = midY - dy3
		let y4: CGFloat = midY - dy4
		let y5: CGFloat = midY - dy5
		let y6: CGFloat = midY + dy5
		let y7: CGFloat = midY + dy4
		let y8: CGFloat = midY + dy3
		let y9: CGFloat = midY + dy2
		let y10: CGFloat = midY + dy1

		let a1: CGFloat = w * a
		let a2: CGFloat = h * a
		let val1: CGFloat = 0.991_44
		let val2: CGFloat = 0.923_88
		let val3: CGFloat = 0.793_35
		let val4: CGFloat = 0.608_76
		let val5: CGFloat = 0.382_68
		let val6: CGFloat = 0.130_53
		let sdx1: CGFloat = a1 * val1
		let sdx2: CGFloat = a1 * val2
		let sdx3: CGFloat = a1 * val3
		let sdx4: CGFloat = a1 * val4
		let sdx5: CGFloat = a1 * val5
		let sdx6: CGFloat = a1 * val6
		let sdy1: CGFloat = a2 * val1
		let sdy2: CGFloat = a2 * val2
		let sdy3: CGFloat = a2 * val3
		let sdy4: CGFloat = a2 * val4
		let sdy5: CGFloat = a2 * val5
		let sdy6: CGFloat = a2 * val6
		let sx1: CGFloat = midX - sdx1
		let sx2: CGFloat = midX - sdx2
		let sx3: CGFloat = midX - sdx3
		let sx4: CGFloat = midX - sdx4
		let sx5: CGFloat = midX - sdx5
		let sx6: CGFloat = midX - sdx6
		let sx7: CGFloat = midX + sdx6
		let sx8: CGFloat = midX + sdx5
		let sx9: CGFloat = midX + sdx4
		let sx10: CGFloat = midX + sdx3
		let sx11: CGFloat = midX + sdx2
		let sx12: CGFloat = midX + sdx1

		let sy1: CGFloat = midY - sdy1
		let sy2: CGFloat = midY - sdy2
		let sy3: CGFloat = midY - sdy3
		let sy4: CGFloat = midY - sdy4
		let sy5: CGFloat = midY - sdy5
		let sy6: CGFloat = midY - sdy6
		let sy7: CGFloat = midY + sdy6
		let sy8: CGFloat = midY + sdy5
		let sy9: CGFloat = midY + sdy4
		let sy10: CGFloat = midY + sdy3
		let sy11: CGFloat = midY + sdy2
		let sy12: CGFloat = midY + sdy1
		let yVal: CGFloat = midY - a2

		let path = CGMutablePath()
		path.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y + midY)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx1), y: CGFloat(y + sy6)))
		path.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y5)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx2), y: CGFloat(y + sy5)))
		path.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y4)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx3), y: CGFloat(y + sy4)))
		path.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y3)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx4), y: CGFloat(y + sy3)))
		path.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y2)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx5), y: CGFloat(y + sy2)))
		path.addLine(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y1)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx6), y: CGFloat(y + sy1)))
		path.addLine(to: CGPoint(x: CGFloat(x + midX), y: CGFloat(y)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx7), y: CGFloat(y + sy1)))
		path.addLine(to: CGPoint(x: CGFloat(x + x6), y: CGFloat(y + y1)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx8), y: CGFloat(y + sy2)))
		path.addLine(to: CGPoint(x: CGFloat(x + x7), y: CGFloat(y + y2)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx9), y: CGFloat(y + sy3)))
		path.addLine(to: CGPoint(x: CGFloat(x + x8), y: CGFloat(y + y3)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx10), y: CGFloat(y + sy4)))
		path.addLine(to: CGPoint(x: CGFloat(x + x9), y: CGFloat(y + y4)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx11), y: CGFloat(y + sy5)))
		path.addLine(to: CGPoint(x: CGFloat(x + x10), y: CGFloat(y + y5)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx12), y: CGFloat(y + sy6)))
		path.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + midY)))

		path.addLine(to: CGPoint(x: CGFloat(x + sx12), y: CGFloat(y + sy7)))
		path.addLine(to: CGPoint(x: CGFloat(x + x10), y: CGFloat(y + y6)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx11), y: CGFloat(y + sy8)))
		path.addLine(to: CGPoint(x: CGFloat(x + x9), y: CGFloat(y + y7)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx10), y: CGFloat(y + sy9)))
		path.addLine(to: CGPoint(x: CGFloat(x + x8), y: CGFloat(y + y8)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx9), y: CGFloat(y + sy10)))
		path.addLine(to: CGPoint(x: CGFloat(x + x7), y: CGFloat(y + y9)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx8), y: CGFloat(y + sy11)))
		path.addLine(to: CGPoint(x: CGFloat(x + x6), y: CGFloat(y + y10)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx7), y: CGFloat(y + sy12)))
		path.addLine(to: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + h)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx6), y: CGFloat(y + sy12)))
		path.addLine(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y10)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx5), y: CGFloat(y + sy11)))
		path.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y9)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx4), y: CGFloat(y + sy10)))
		path.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y8)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx3), y: CGFloat(y + sy9)))
		path.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y7)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx2), y: CGFloat(y + sy8)))
		path.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y6)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx1), y: CGFloat(y + sy7)))
		path.closeSubpath()

		let ang: CGFloat = ((.pi * 45) / 180)
		let ix: CGFloat = a1 * cos(ang)
		let iy: CGFloat = a2 * sin(ang)
		let l: CGFloat = midX - ix
		let t: CGFloat = midY - iy
		let r: CGFloat = midX + ix
		let b: CGFloat = midY + iy

		let handles = [CGPoint(midX, yVal)]
		let textFrame = CGRect(x: x + l, y: y + t, width: r - l, height: b - t)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func thirtyTwoPointStar(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let a: CGFloat = modifiers[0]
		let midX: CGFloat = w * 0.5
		let midY: CGFloat = h * 0.5

		let val1: CGFloat = 0.980_79
		let val2: CGFloat = 0.923_88
		let val3: CGFloat = 0.831_47
		let val4: CGFloat = 0.555_57
		let val5: CGFloat = 0.382_68
		let val6: CGFloat = 0.195_09
		let dx1: CGFloat = midX * val1
		let dx2: CGFloat = midX * val2
		let dx3: CGFloat = midX * val3
		let dx4: CGFloat = midX * CGFloat(cosf(Float.pi / 4))
		let dx5: CGFloat = midX * val4
		let dx6: CGFloat = midX * val5
		let dx7: CGFloat = midX * val6
		let dy1: CGFloat = midY * val1
		let dy2: CGFloat = midY * val2
		let dy3: CGFloat = midY * val3
		let dy4: CGFloat = midY * CGFloat(sinf(Float.pi / 4))
		let dy5: CGFloat = midY * val4
		let dy6: CGFloat = midY * val5
		let dy7: CGFloat = midY * val6
		let x1: CGFloat = midX - dx1
		let x2: CGFloat = midX - dx2
		let x3: CGFloat = midX - dx3
		let x4: CGFloat = midX - dx4
		let x5: CGFloat = midX - dx5
		let x6: CGFloat = midX - dx6
		let x7: CGFloat = midX - dx7
		let x8: CGFloat = midX + dx7
		let x9: CGFloat = midX + dx6
		let x10: CGFloat = midX + dx5
		let x11: CGFloat = midX + dx4
		let x12: CGFloat = midX + dx3
		let x13: CGFloat = midX + dx2
		let x14: CGFloat = midX + dx1

		let y1: CGFloat = midY - dy1
		let y2: CGFloat = midY - dy2
		let y3: CGFloat = midY - dy3
		let y4: CGFloat = midY - dy4
		let y5: CGFloat = midY - dy5
		let y6: CGFloat = midY - dy6
		let y7: CGFloat = midY - dy7
		let y8: CGFloat = midY + dy7
		let y9: CGFloat = midY + dy6
		let y10: CGFloat = midY + dy5
		let y11: CGFloat = midY + dy4
		let y12: CGFloat = midY + dy3
		let y13: CGFloat = midY + dy2
		let y14: CGFloat = midY + dy1
		let a1: CGFloat = w * a
		let a2: CGFloat = h * a
		let v1: CGFloat = 0.995_18
		let v2: CGFloat = 0.956_94
		let v3: CGFloat = 0.881_92
		let v4: CGFloat = 0.773_01
		let v5: CGFloat = 0.634_39
		let v6: CGFloat = 0.471_40
		let v7: CGFloat = 0.290_28
		let v8: CGFloat = 0.098_02

		let sdx1: CGFloat = a1 * v1
		let sdx2: CGFloat = a1 * v2
		let sdx3: CGFloat = a1 * v3
		let sdx4: CGFloat = a1 * v4
		let sdx5: CGFloat = a1 * v5
		let sdx6: CGFloat = a1 * v6
		let sdx7: CGFloat = a1 * v7
		let sdx8: CGFloat = a1 * v8
		let sdy1: CGFloat = a2 * v1
		let sdy2: CGFloat = a2 * v2
		let sdy3: CGFloat = a2 * v3
		let sdy4: CGFloat = a2 * v4
		let sdy5: CGFloat = a2 * v5
		let sdy6: CGFloat = a2 * v6
		let sdy7: CGFloat = a2 * v7
		let sdy8: CGFloat = a2 * v8

		let sx1: CGFloat = midX - sdx1
		let sx2: CGFloat = midX - sdx2
		let sx3: CGFloat = midX - sdx3
		let sx4: CGFloat = midX - sdx4
		let sx5: CGFloat = midX - sdx5
		let sx6: CGFloat = midX - sdx6
		let sx7: CGFloat = midX - sdx7
		let sx8: CGFloat = midX - sdx8
		let sx9: CGFloat = midX + sdx8
		let sx10: CGFloat = midX + sdx7
		let sx11: CGFloat = midX + sdx6
		let sx12: CGFloat = midX + sdx5
		let sx13: CGFloat = midX + sdx4
		let sx14: CGFloat = midX + sdx3
		let sx15: CGFloat = midX + sdx2
		let sx16: CGFloat = midX + sdx1
		let sy1: CGFloat = midY - sdy1
		let sy2: CGFloat = midY - sdy2
		let sy3: CGFloat = midY - sdy3
		let sy4: CGFloat = midY - sdy4
		let sy5: CGFloat = midY - sdy5
		let sy6: CGFloat = midY - sdy6
		let sy7: CGFloat = midY - sdy7
		let sy8: CGFloat = midY - sdy8
		let sy9: CGFloat = midY + sdy8
		let sy10: CGFloat = midY + sdy7
		let sy11: CGFloat = midY + sdy6
		let sy12: CGFloat = midY + sdy5
		let sy13: CGFloat = midY + sdy4
		let sy14: CGFloat = midY + sdy3
		let sy15: CGFloat = midY + sdy2
		let sy16: CGFloat = midY + sdy1
		let yVal: CGFloat = midY - a2

		let path = CGMutablePath()
		path.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y + midY)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx1), y: CGFloat(y + sy8)))
		path.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y7)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx2), y: CGFloat(y + sy7)))
		path.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y6)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx3), y: CGFloat(y + sy6)))
		path.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y5)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx4), y: CGFloat(y + sy5)))
		path.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y4)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx5), y: CGFloat(y + sy4)))
		path.addLine(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y3)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx6), y: CGFloat(y + sy3)))
		path.addLine(to: CGPoint(x: CGFloat(x + x6), y: CGFloat(y + y2)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx7), y: CGFloat(y + sy2)))
		path.addLine(to: CGPoint(x: CGFloat(x + x7), y: CGFloat(y + y1)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx8), y: CGFloat(y + sy1)))
		path.addLine(to: CGPoint(x: CGFloat(x + midX), y: CGFloat(y)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx9), y: CGFloat(y + sy1)))
		path.addLine(to: CGPoint(x: CGFloat(x + x8), y: CGFloat(y + y1)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx10), y: CGFloat(y + sy2)))

		path.addLine(to: CGPoint(x: CGFloat(x + x9), y: CGFloat(y + y2)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx11), y: CGFloat(y + sy3)))
		path.addLine(to: CGPoint(x: CGFloat(x + x10), y: CGFloat(y + y3)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx12), y: CGFloat(y + sy4)))
		path.addLine(to: CGPoint(x: CGFloat(x + x11), y: CGFloat(y + y4)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx13), y: CGFloat(y + sy5)))
		path.addLine(to: CGPoint(x: CGFloat(x + x12), y: CGFloat(y + y5)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx14), y: CGFloat(y + sy6)))
		path.addLine(to: CGPoint(x: CGFloat(x + x13), y: CGFloat(y + y6)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx15), y: CGFloat(y + sy7)))
		path.addLine(to: CGPoint(x: CGFloat(x + x14), y: CGFloat(y + y7)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx16), y: CGFloat(y + sy8)))
		path.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + midY)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx16), y: CGFloat(y + sy9)))
		path.addLine(to: CGPoint(x: CGFloat(x + x14), y: CGFloat(y + y8)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx15), y: CGFloat(y + sy10)))
		path.addLine(to: CGPoint(x: CGFloat(x + x13), y: CGFloat(y + y9)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx14), y: CGFloat(y + sy11)))
		path.addLine(to: CGPoint(x: CGFloat(x + x12), y: CGFloat(y + y10)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx13), y: CGFloat(y + sy12)))

		path.addLine(to: CGPoint(x: CGFloat(x + x11), y: CGFloat(y + y11)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx12), y: CGFloat(y + sy13)))
		path.addLine(to: CGPoint(x: CGFloat(x + x10), y: CGFloat(y + y12)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx11), y: CGFloat(y + sy14)))
		path.addLine(to: CGPoint(x: CGFloat(x + x9), y: CGFloat(y + y13)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx10), y: CGFloat(y + sy15)))
		path.addLine(to: CGPoint(x: CGFloat(x + x8), y: CGFloat(y + y14)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx9), y: CGFloat(y + sy16)))
		path.addLine(to: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + h)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx8), y: CGFloat(y + sy16)))
		path.addLine(to: CGPoint(x: CGFloat(x + x7), y: CGFloat(y + y14)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx7), y: CGFloat(y + sy15)))
		path.addLine(to: CGPoint(x: CGFloat(x + x6), y: CGFloat(y + y13)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx6), y: CGFloat(y + sy14)))
		path.addLine(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y12)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx5), y: CGFloat(y + sy13)))
		path.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y11)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx4), y: CGFloat(y + sy12)))
		path.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y10)))

		path.addLine(to: CGPoint(x: CGFloat(x + sx3), y: CGFloat(y + sy11)))
		path.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y9)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx2), y: CGFloat(y + sy10)))
		path.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y8)))
		path.addLine(to: CGPoint(x: CGFloat(x + sx1), y: CGFloat(y + sy9)))
		path.closeSubpath()
		let ang: CGFloat = ((.pi * 45) / 180)
		let ix: CGFloat = a1 * cos(ang)
		let iy: CGFloat = a2 * sin(ang)
		let l: CGFloat = midX - ix
		let t: CGFloat = midY - iy
		let r: CGFloat = midX + ix
		let b: CGFloat = midY + iy

		let handles = [CGPoint(midX, yVal)]
		let textFrame = CGRect(x: x + l, y: y + t, width: r - l, height: b - t)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	/*
	 func upRibbon(frame: CGRect) -> PresetPathInfo {
	 let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
	 let a1: CGFloat = modifiers[0]
	 let a2: CGFloat = modifiers[1] * 0.5
	 let midX: CGFloat = w * 0.5
	 let w8: CGFloat = w * (1.0 / 8.0)
	 let x1: CGFloat = w - w8
	 let dx2: CGFloat = w * a2
	 let x2: CGFloat = midX - dx2
	 let x9: CGFloat = midX + dx2
	 let w32: CGFloat = w * (1.0 / 32.0)
	 let x3: CGFloat = x2 + w32
	 let x8: CGFloat = x9 - w32
	 let x5: CGFloat = x2 + w8
	 let x6: CGFloat = x9 - w8
	 let x4: CGFloat = x5 - w32
	 let x7: CGFloat = x6 + w32
	 let dy2: CGFloat = h * a1
	 let dy1: CGFloat = dy2 * 0.5
	 let y1: CGFloat = h - dy1
	 let y2: CGFloat = h - dy2
	 let y4: CGFloat = dy2
	 let y3: CGFloat = (y4 + h) * 0.5
	 let hR: CGFloat = dy2 * 0.25
	 let y5: CGFloat = h - hR
	 let y6: CGFloat = y1 - hR

	 let path1 = CGMutablePath()
	 path1.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h)))
	 path1.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + h)))

	 var controlPoint : [CGPoint] = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x4 + w32, y + h - hR), framePoint2: CGPoint(x + x4, y + h), startAngle: 0, endAngle:  .pi/2, rx: w32, ry: hR)
	 path1.addCurve(to: CGPoint(x + x4 + w32, y + h - hR), control1: controlPoint[1], control2: controlPoint[0])

	 controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x4, y + y1), framePoint2: CGPoint(x + x4 + w32, y + h - hR), startAngle: (.pi/2)*3, endAngle:  0, rx: w32, ry: hR)
	 path1.addCurve(to: CGPoint(x + x4, y + y1), control1: controlPoint[1], control2: controlPoint[0])

	 path1.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y1)))

	 controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x3, y + y1), framePoint2: CGPoint(x + x3 - w32, y + y1 - hR), startAngle: (.pi/2), endAngle:  .pi, rx: w32, ry: hR)
	 path1.addCurve(to: CGPoint(x + x3 - w32, y + y1 - hR), control1: controlPoint[0], control2: controlPoint[1])

	 controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x3 - w32, y + y1 - hR), framePoint2: CGPoint(x + x3, y + y2), startAngle: .pi, endAngle:  (.pi/2)*3, rx: w32, ry: hR)
	 path1.addCurve(to: CGPoint(x + x3, y + y2), control1: controlPoint[0], control2: controlPoint[1])

	 path1.addLine(to: CGPoint(x: CGFloat(x + x8), y: CGFloat(y + y2)))

	 controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x8, y + y2), framePoint2: CGPoint(x + x8 + w32, y + y2 + hR), startAngle: (.pi/2)*3, endAngle:  0, rx: w32, ry: hR)
	 path1.addCurve(to: CGPoint(x + x8 + w32, y + y2 + hR), control1: controlPoint[0], control2: controlPoint[1])

	 controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x8 + w32, y + y2 + hR), framePoint2: CGPoint(x + x8, y + y1), startAngle: 0, endAngle:  (.pi/2), rx: w32, ry: hR)
	 path1.addCurve(to: CGPoint(x + x8, y + y1), control1: controlPoint[0], control2: controlPoint[1])

	 path1.addLine(to: CGPoint(x: CGFloat(x + x7), y: CGFloat(y + y1)))

	 controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x7 - w32, y + y1 + hR), framePoint2: CGPoint(x + x7, y + y1), startAngle: .pi, endAngle:  3*(.pi/2), rx: w32, ry: hR)
	 path1.addCurve(to: CGPoint(x + x7 - w32, y + y1 + hR), control1: controlPoint[1], control2: controlPoint[0])

	 controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x7, y + h), framePoint2: CGPoint(x + x7 - w32, y + y1 + hR), startAngle: .pi/2, endAngle:  .pi, rx: w32, ry: hR)
	 path1.addCurve(to: CGPoint(x + x7, y + h), control1: controlPoint[1], control2: controlPoint[0])

	 path1.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
	 path1.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y3)))
	 path1.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + y4)))
	 path1.addLine(to: CGPoint(x: CGFloat(x + x9), y: CGFloat(y + y4)))
	 path1.addLine(to: CGPoint(x: CGFloat(x + x9), y: CGFloat(y + hR)))

	 controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x9 - w32, y), framePoint2: CGPoint(x + x9, y + hR), startAngle: 3*(.pi/2), endAngle:  0, rx: w32, ry: hR)
	 path1.addCurve(to: CGPoint(x + x9 - w32, y), control1: controlPoint[1], control2: controlPoint[0])

	 path1.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y)))

	 controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x3 - w32, y + hR), framePoint2: CGPoint(x + x3, y), startAngle: .pi, endAngle: 3*(.pi/2), rx: w32, ry: hR)
	 path1.addCurve(to: CGPoint(x + x3 - w32, y + hR), control1: controlPoint[1], control2: controlPoint[0])

	 path1.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y4)))
	 path1.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + y4)))
	 path1.addLine(to: CGPoint(x: CGFloat(x + w8), y: CGFloat(y + y3)))
	 path1.closeSubpath()

	 let path2 = CGMutablePath()
	 path2.move(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y5)))

	 controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x5 - w32, y + y1), framePoint2: CGPoint(x + x5, y + y5), startAngle: (.pi/2)*3, endAngle: 0, rx: w32, ry: hR)
	 path2.addCurve(to: CGPoint(x + x5 - w32, y + y1), control1: controlPoint[1], control2: controlPoint[0])

	 path2.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y1)))

	 controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x3, y + y1), framePoint2: CGPoint(x + x3 - w32, y + y1 - hR), startAngle: .pi/2, endAngle: .pi, rx: w32, ry: hR)
	 path2.addCurve(to: CGPoint(x + x3 - w32, y + y1 - hR), control1: controlPoint[0], control2: controlPoint[1])

	 controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x3 - w32, y + y1 - hR), framePoint2: CGPoint(x + x3, y + y2), startAngle: .pi, endAngle: 3*(.pi/2), rx: w32, ry: hR)
	 path2.addCurve(to: CGPoint(x + x3, y + y2), control1: controlPoint[0], control2: controlPoint[1])

	 path2.addLine(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y2)))
	 path2.closeSubpath()
	 path2.move(to: CGPoint(x: CGFloat(x + x6), y: CGFloat(y + y5)))

	 controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x6, y + y5), framePoint2: CGPoint(x + x6 + w32, y + y1), startAngle: .pi, endAngle: 3*(.pi/2), rx: w32, ry: hR)
	 path2.addCurve(to: CGPoint(x + x6 + w32, y + y1), control1: controlPoint[0], control2: controlPoint[1])

	 path2.addLine(to: CGPoint(x: CGFloat(x + x8), y: CGFloat(y + y1)))

	 controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x8 + w32, y + y1 - hR), framePoint2: CGPoint(x + x8, y + y1), startAngle: 0, endAngle: (.pi/2), rx: w32, ry: hR)
	 path2.addCurve(to: CGPoint(x + x8 + w32, y + y1 - hR), control1: controlPoint[1], control2: controlPoint[0])

	 controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x8, y + y2), framePoint2: CGPoint(x + x8 + w32, y + y1 - hR), startAngle: 3*(.pi/2), endAngle: 0, rx: w32, ry: hR)
	 path2.addCurve(to: CGPoint(x + x8, y + y2), control1: controlPoint[1], control2: controlPoint[0])

	 path2.addLine(to: CGPoint(x: CGFloat(x + x6), y: CGFloat(y + y2)))
	 path2.closeSubpath()

	 let path3 = CGMutablePath()
	 path3.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h)))
	 path3.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + h)))

	 controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x4 + w32, y + h - hR), framePoint2: CGPoint(x + x4, y + h), startAngle: 0, endAngle: (.pi/2), rx: w32, ry: hR)
	 path3.addCurve(to: CGPoint(x + x4 + w32, y + h - hR), control1: controlPoint[1], control2: controlPoint[0])

	 controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x4, y + y1), framePoint2: CGPoint(x + x4 + w32, y + h - hR), startAngle: 3*(.pi/2), endAngle: 0, rx: w32, ry: hR)
	 path3.addCurve(to: CGPoint(x + x4, y + y1), control1: controlPoint[1], control2: controlPoint[0])

	 path3.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y1)))

	 controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x3, y + y1), framePoint2: CGPoint(x + x3 - w32, y + y1 - hR), startAngle: (.pi/2), endAngle: .pi, rx: w32, ry: hR)
	 path3.addCurve(to: CGPoint(x + x3 - w32, y + y1 - hR), control1: controlPoint[0], control2: controlPoint[1])

	 controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x3 - w32, y + y1 - hR), framePoint2: CGPoint(x + x3, y + y2), startAngle: (.pi), endAngle: (.pi/2)*3, rx: w32, ry: hR)
	 path3.addCurve(to: CGPoint(x + x3, y + y2), control1: controlPoint[0], control2: controlPoint[1])

	 path3.addLine(to: CGPoint(x: CGFloat(x + x8), y: CGFloat(y + y2)))

	 controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x8, y + y2), framePoint2: CGPoint(x + x8 + w32, y + y2 + hR), startAngle: 3*(.pi/2), endAngle: 0, rx: w32, ry: hR)
	 path3.addCurve(to: CGPoint(x + x8 + w32, y + y2 + hR), control1: controlPoint[0], control2: controlPoint[1])

	 controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x8 + w32, y + y2 + hR), framePoint2: CGPoint(x + x8, y + y1), startAngle: 0, endAngle: (.pi/2), rx: w32, ry: hR)
	 path3.addCurve(to: CGPoint(x + x8, y + y1), control1: controlPoint[0], control2: controlPoint[1])

	 path3.addLine(to: CGPoint(x: CGFloat(x + x7), y: CGFloat(y + y1)))

	 controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x7 - w32, y + y1 + hR), framePoint2: CGPoint(x + x7, y + y1), startAngle: .pi, endAngle: 3*(.pi/2), rx: w32, ry: hR)
	 path3.addCurve(to: CGPoint(x + x7 - w32, y + y1 + hR), control1: controlPoint[1], control2: controlPoint[0])

	 controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x7, y + h), framePoint2: CGPoint(x + x7 - w32, y + y1 + hR), startAngle: .pi/2, endAngle: .pi, rx: w32, ry: hR)
	 path3.addCurve(to: CGPoint(x + x7, y + h), control1: controlPoint[1], control2: controlPoint[0])

	 path3.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
	 path3.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y3)))
	 path3.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + y4)))
	 path3.addLine(to: CGPoint(x: CGFloat(x + x9), y: CGFloat(y + y4)))
	 path3.addLine(to: CGPoint(x: CGFloat(x + x9), y: CGFloat(y + hR)))

	 controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x9 - w32, y), framePoint2: CGPoint(x + x9, y + hR), startAngle: (.pi/2)*3, endAngle: 0, rx: w32, ry: hR)
	 path3.addCurve(to: CGPoint(x + x9, y + hR), control1: controlPoint[1], control2: controlPoint[0])

	 path3.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y)))

	 controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x3 - w32, y + hR), framePoint2: CGPoint(x + x3, y), startAngle: .pi, endAngle: (.pi/2)*3, rx: w32, ry: hR)
	 path3.addCurve(to: CGPoint(x + x3 - w32, y + hR), control1: controlPoint[1], control2: controlPoint[0])

	 path3.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y4)))
	 path3.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + y4)))
	 path3.addLine(to: CGPoint(x: CGFloat(x + w8), y: CGFloat(y + y3)))
	 path3.closeSubpath()
	 path3.move(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y5)))
	 path3.addLine(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y2)))
	 path3.move(to: CGPoint(x: CGFloat(x + x6), y: CGFloat(y + y5)))
	 path3.addLine(to: CGPoint(x: CGFloat(x + x6), y: CGFloat(y + y2)))
	 path3.move(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y6)))
	 path3.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y4)))
	 path3.move(to: CGPoint(x: CGFloat(x + x9), y: CGFloat(y + y4)))
	 path3.addLine(to: CGPoint(x: CGFloat(x + x9), y: CGFloat(y + y6)))

	 let pathArray: [CGMutablePath] = [path1,path2,path3]
	 let textFrame = CGRect(x: x + x2, y: y, width: x9 - x2, height: y2)
	 let animationFrame = frame
	 return PresetPathInfo(paths: pathArray, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame)
	 }
	 */
	func upRibbon(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let a1: CGFloat = modifiers[0]
		let a2: CGFloat = modifiers[1] * 0.5
		let midX: CGFloat = w * 0.5

		// MARK: Unused

//		let midY: CGFloat = h * 0.5
		let w8: CGFloat = w * (1.0 / 8.0)
		let x1: CGFloat = w - w8
		let dx2: CGFloat = w * a2
		let x2: CGFloat = midX - dx2
		let x9: CGFloat = midX + dx2
		let w32: CGFloat = w * (1.0 / 32.0)
		let x3: CGFloat = x2 + w32
		let x8: CGFloat = x9 - w32
		let x5: CGFloat = x2 + w8
		let x6: CGFloat = x9 - w8
		let x4: CGFloat = x5 - w32
		let x7: CGFloat = x6 + w32
		let dy2: CGFloat = h * a1
		let dy1: CGFloat = dy2 * 0.5
		let y1: CGFloat = h - dy1
		let y2: CGFloat = h - dy2
		let y4: CGFloat = dy2
		let y3: CGFloat = (y4 + h) * 0.5
		let hR: CGFloat = dy2 * 0.25
		let y5: CGFloat = h - hR
		let y6: CGFloat = y1 - hR

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h)))
		path1.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + h)))

		var framePoint1 = CGPoint(x + x4 + w32, y + h - hR)
		var framePoint2 = CGPoint(x + x4, y + h)
		var startAngle: CGFloat = 0
		var endAngle: CGFloat = .pi / 2

		var controlPoint: [CGPoint] = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: w32, ry: hR)
		path1.addCurve(to: framePoint1, control1: controlPoint[1], control2: controlPoint[0])

		framePoint1 = CGPoint(x + x4, y + y1)
		framePoint2 = CGPoint(x + x4 + w32, y + h - hR)
		startAngle = (.pi / 2) * 3
		endAngle = 0

		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: w32, ry: hR)
		path1.addCurve(to: framePoint1, control1: controlPoint[1], control2: controlPoint[0])

		path1.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y1)))

		framePoint1 = CGPoint(x + x3, y + y1)
		framePoint2 = CGPoint(x + x3 - w32, y + y1 - hR)
		startAngle = (.pi / 2)
		endAngle = .pi

		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: w32, ry: hR)
		path1.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])

		framePoint1 = CGPoint(x + x3 - w32, y + y1 - hR)
		framePoint2 = CGPoint(x + x3, y + y2)
		startAngle = .pi
		endAngle = 3 * (.pi / 2)

		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: w32, ry: hR)
		path1.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])

		path1.addLine(to: CGPoint(x: CGFloat(x + x8), y: CGFloat(y + y2)))

		framePoint1 = CGPoint(x + x8, y + y2)
		framePoint2 = CGPoint(x + x8 + w32, y + y2 + hR)
		startAngle = 3 * (.pi / 2)
		endAngle = 0

		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: w32, ry: hR)
		path1.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])

		framePoint1 = CGPoint(x + x8 + w32, y + y2 + hR)
		framePoint2 = CGPoint(x + x8, y + y1)
		startAngle = 0
		endAngle = (.pi / 2)

		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: w32, ry: hR)
		path1.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])

		path1.addLine(to: CGPoint(x: CGFloat(x + x7), y: CGFloat(y + y1)))

		framePoint1 = CGPoint(x + x7 - w32, y + y1 + hR)
		framePoint2 = CGPoint(x + x7, y + y1)
		startAngle = .pi
		endAngle = 3 * (.pi / 2)

		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: w32, ry: hR)
		path1.addCurve(to: framePoint1, control1: controlPoint[0], control2: controlPoint[1])

		framePoint1 = CGPoint(x + x7, y + h)
		framePoint2 = CGPoint(x + x7 - w32, y + y1 + hR)
		startAngle = (.pi / 2)
		endAngle = .pi

		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: w32, ry: hR)
		path1.addCurve(to: framePoint1, control1: controlPoint[1], control2: controlPoint[0])

		path1.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
		path1.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y3)))
		path1.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + y4)))
		path1.addLine(to: CGPoint(x: CGFloat(x + x9), y: CGFloat(y + y4)))
		path1.addLine(to: CGPoint(x: CGFloat(x + x9), y: CGFloat(y + hR)))

		framePoint1 = CGPoint(x + x9 - w32, y)
		framePoint2 = CGPoint(x + x9, y + hR)
		startAngle = 3 * (.pi / 2)
		endAngle = 0

		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: w32, ry: hR)
		path1.addCurve(to: framePoint1, control1: controlPoint[1], control2: controlPoint[0])

		path1.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y)))

		framePoint1 = CGPoint(x + x3 - w32, y + hR)
		framePoint2 = CGPoint(x + x3, y)
		startAngle = .pi
		endAngle = 3 * (.pi / 2)

		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: w32, ry: hR)
		path1.addCurve(to: framePoint1, control1: controlPoint[1], control2: controlPoint[0])

		path1.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y4)))
		path1.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + y4)))
		path1.addLine(to: CGPoint(x: CGFloat(x + w8), y: CGFloat(y + y3)))
		path1.closeSubpath()

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y5)))

		framePoint1 = CGPoint(x + x5 - w32, y + y1)
		framePoint2 = CGPoint(x + x5, y + y5)
		startAngle = 3 * (.pi / 2)
		endAngle = 0

		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: w32, ry: hR)
		path2.addCurve(to: framePoint1, control1: controlPoint[1], control2: controlPoint[0])

		path2.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y1)))

		framePoint1 = CGPoint(x + x3, y + y1)
		framePoint2 = CGPoint(x + x3 - w32, y + y1 - hR)
		startAngle = (.pi / 2)
		endAngle = .pi

		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: w32, ry: hR)
		path2.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])

		framePoint1 = CGPoint(x + x3 - w32, y + y1 - hR)
		framePoint2 = CGPoint(x + x3, y + y2)
		startAngle = .pi
		endAngle = 3 * (.pi / 2)

		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: w32, ry: hR)
		path2.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])

		path2.addLine(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y2)))
		path2.closeSubpath()
		path2.move(to: CGPoint(x: CGFloat(x + x6), y: CGFloat(y + y5)))

		framePoint1 = CGPoint(x + x6, y + y5)
		framePoint2 = CGPoint(x + x6 + w32, y + y1)
		startAngle = .pi
		endAngle = 3 * (.pi / 2)

		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: w32, ry: hR)
		path2.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])

		path2.addLine(to: CGPoint(x: CGFloat(x + x8), y: CGFloat(y + y1)))

		framePoint1 = CGPoint(x + x8 + w32, y + y1 - hR)
		framePoint2 = CGPoint(x + x8, y + y1)
		startAngle = 0
		endAngle = (.pi / 2)

		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: w32, ry: hR)
		path2.addCurve(to: framePoint1, control1: controlPoint[1], control2: controlPoint[0])

		framePoint1 = CGPoint(x + x8, y + y2)
		framePoint2 = CGPoint(x + x8 + w32, y + y1 - hR)
		startAngle = 3 * (.pi / 2)
		endAngle = 0

		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: w32, ry: hR)
		path2.addCurve(to: framePoint1, control1: controlPoint[1], control2: controlPoint[0])

		path2.addLine(to: CGPoint(x: CGFloat(x + x6), y: CGFloat(y + y2)))
		path2.closeSubpath()

		let path3 = CGMutablePath()
		path3.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h)))
		path3.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + h)))

		framePoint1 = CGPoint(x + x4 + w32, y + h - hR)
		framePoint2 = CGPoint(x + x4, y + h)
		startAngle = 0
		endAngle = (.pi / 2)

		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: w32, ry: hR)
		path3.addCurve(to: framePoint1, control1: controlPoint[1], control2: controlPoint[0])

		framePoint1 = CGPoint(x + x4, y + y1)
		framePoint2 = CGPoint(x + x4 + w32, y + h - hR)
		startAngle = 3 * (.pi / 2)
		endAngle = 0

		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: w32, ry: hR)
		path3.addCurve(to: framePoint1, control1: controlPoint[1], control2: controlPoint[0])

		path3.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y1)))

		framePoint1 = CGPoint(x + x3, y + y1)
		framePoint2 = CGPoint(x + x3 - w32, y + y1 - hR)
		startAngle = (.pi / 2)
		endAngle = .pi

		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: w32, ry: hR)
		path3.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])

		framePoint1 = CGPoint(x + x3 - w32, y + y1 - hR)
		framePoint2 = CGPoint(x + x3, y + y2)
		startAngle = .pi
		endAngle = 3 * (.pi / 2)

		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: w32, ry: hR)
		path3.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])

		path3.addLine(to: CGPoint(x: CGFloat(x + x8), y: CGFloat(y + y2)))

		framePoint1 = CGPoint(x + x8, y + y2)
		framePoint2 = CGPoint(x + x8 + w32, y + y2 + hR)
		startAngle = 3 * (.pi / 2)
		endAngle = 0

		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: w32, ry: hR)
		path3.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])

		framePoint1 = CGPoint(x + x8 + w32, y + y2 + hR)
		framePoint2 = CGPoint(x + x8, y + y1)
		startAngle = 0
		endAngle = (.pi / 2)

		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: w32, ry: hR)
		path3.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])

		path3.addLine(to: CGPoint(x: CGFloat(x + x7), y: CGFloat(y + y1)))

		framePoint1 = CGPoint(x + x7 - w32, y + y1 + hR)
		framePoint2 = CGPoint(x + x7, y + y1)
		startAngle = .pi
		endAngle = 3 * (.pi / 2)

		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: w32, ry: hR)
		path3.addCurve(to: framePoint1, control1: controlPoint[1], control2: controlPoint[0])

		framePoint1 = CGPoint(x + x7, y + h)
		framePoint2 = CGPoint(x + x7 - w32, y + y1 + hR)
		startAngle = (.pi / 2)
		endAngle = .pi

		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: w32, ry: hR)
		path3.addCurve(to: framePoint1, control1: controlPoint[1], control2: controlPoint[0])

		path3.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
		path3.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y3)))
		path3.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + y4)))
		path3.addLine(to: CGPoint(x: CGFloat(x + x9), y: CGFloat(y + y4)))
		path3.addLine(to: CGPoint(x: CGFloat(x + x9), y: CGFloat(y + hR)))

		framePoint1 = CGPoint(x + x9 - w32, y)
		framePoint2 = CGPoint(x + x9, y + hR)
		startAngle = (.pi / 2) * 3
		endAngle = 0

		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: w32, ry: hR)
		path3.addCurve(to: framePoint1, control1: controlPoint[1], control2: controlPoint[0])

		path3.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y)))

		framePoint1 = CGPoint(x + x3 - w32, y + hR)
		framePoint2 = CGPoint(x + x3, y)
		startAngle = .pi
		endAngle = (.pi / 2) * 3

		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: w32, ry: hR)
		path3.addCurve(to: framePoint1, control1: controlPoint[1], control2: controlPoint[0])

		path3.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y4)))
		path3.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + y4)))
		path3.addLine(to: CGPoint(x: CGFloat(x + w8), y: CGFloat(y + y3)))
		path3.closeSubpath()
		path3.move(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y5)))
		path3.addLine(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y2)))
		path3.move(to: CGPoint(x: CGFloat(x + x6), y: CGFloat(y + y5)))
		path3.addLine(to: CGPoint(x: CGFloat(x + x6), y: CGFloat(y + y2)))
		path3.move(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y6)))
		path3.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y4)))
		path3.move(to: CGPoint(x: CGFloat(x + x9), y: CGFloat(y + y4)))
		path3.addLine(to: CGPoint(x: CGFloat(x + x9), y: CGFloat(y + y6)))

		let pathArray = [path1, path2, path3]
		let handles = [CGPoint(midX, y2), CGPoint(x2, h)]
		let textFrame = CGRect(x: x + x2, y: y, width: CGFloat(x9 - x2), height: CGFloat(y2))
		let animationFrame = frame
		let connector = [[midX, 0, 270], [w8, y3, 180], [midX, y2, 90], [x1, y3, 0]]
		return PresetPathInfo(paths: pathArray, handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func downRibbon(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let a1: CGFloat = modifiers[0]
		let a2: CGFloat = modifiers[1] * 0.5
		let midX: CGFloat = w * 0.5
		let w8: CGFloat = w * (1.0 / 8.0)
		let x1: CGFloat = w - w8
		let dx2: CGFloat = w * a2
		let x2: CGFloat = midX - dx2
		let x9: CGFloat = midX + dx2
		let w32: CGFloat = w * (1.0 / 32.0)
		let x3: CGFloat = x2 + w32
		let x8: CGFloat = x9 - w32
		let x5: CGFloat = x2 + w8
		let x6: CGFloat = x9 - w8
		let x4: CGFloat = x5 - w32
		let x7: CGFloat = x6 + w32
		let y2: CGFloat = h * a1
		let y1: CGFloat = y2 * 0.5
		let y4: CGFloat = h - y2
		let y3: CGFloat = y4 * 0.5
		let hR: CGFloat = y2 * 0.25
		let y5: CGFloat = h - hR
		let y6: CGFloat = y2 - hR

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
		path1.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y)))

		var controlPoint: [CGPoint] = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x4, y), framePoint2: CGPoint(x + x4 + w32, y + hR), startAngle: (.pi / 2) * 3, endAngle: 0, rx: w32, ry: hR)
		path1.addCurve(to: CGPoint(x + x4 + w32, y + hR), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x4 + w32, y + hR), framePoint2: CGPoint(x + x4, y + y1), startAngle: 0, endAngle: .pi / 2, rx: w32, ry: hR)
		path1.addCurve(to: CGPoint(x + x4, y + y1), control1: controlPoint[0], control2: controlPoint[1])

		path1.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y1)))

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x3 - w32, y + y1 + hR), framePoint2: CGPoint(x + x3, y + y1), startAngle: .pi, endAngle: (.pi / 2) * 3, rx: w32, ry: hR)
		path1.addCurve(to: CGPoint(x + x3 - w32, y + y1 + hR), control1: controlPoint[1], control2: controlPoint[0])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x3, y + y2), framePoint2: CGPoint(x + x3 - w32, y + y1 + hR), startAngle: .pi / 2, endAngle: .pi, rx: w32, ry: hR)
		path1.addCurve(to: CGPoint(x + x3, y + y2), control1: controlPoint[1], control2: controlPoint[0])

		path1.addLine(to: CGPoint(x: CGFloat(x + x8), y: CGFloat(y + y2)))

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x8 + w32, y + y2 - hR), framePoint2: CGPoint(x + x8, y + y2), startAngle: 0, endAngle: .pi / 2, rx: w32, ry: hR)
		path1.addCurve(to: CGPoint(x + x8 + w32, y + y2 - hR), control1: controlPoint[1], control2: controlPoint[0])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x8, y + y1), framePoint2: CGPoint(x + x8 + w32, y + y2 - hR), startAngle: (.pi / 2) * 3, endAngle: 0, rx: w32, ry: hR)
		path1.addCurve(to: CGPoint(x + x8, y + y1), control1: controlPoint[1], control2: controlPoint[0])

		path1.addLine(to: CGPoint(x: CGFloat(x + x7), y: CGFloat(y + y1)))

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x7, y + y1), framePoint2: CGPoint(x + x7 - w32, y + y1 - hR), startAngle: .pi / 2, endAngle: .pi, rx: w32, ry: hR)
		path1.addCurve(to: CGPoint(x + x7 - w32, y + y1 - hR), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x7 - w32, y + y1 - hR), framePoint2: CGPoint(x + x7, y), startAngle: .pi, endAngle: 3 * (.pi / 2), rx: w32, ry: hR)
		path1.addCurve(to: CGPoint(x + x7, y), control1: controlPoint[0], control2: controlPoint[1])

		path1.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path1.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y3)))
		path1.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + y4)))
		path1.addLine(to: CGPoint(x: CGFloat(x + x9), y: CGFloat(y + y4)))
		path1.addLine(to: CGPoint(x: CGFloat(x + x9), y: CGFloat(y + y5)))

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x9, y + y5), framePoint2: CGPoint(x + x9 - w32, y + h), startAngle: 0, endAngle: .pi / 2, rx: w32, ry: hR)
		path1.addCurve(to: CGPoint(x + x9 - w32, y + h), control1: controlPoint[0], control2: controlPoint[1])

		path1.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + h)))

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x3, y + h), framePoint2: CGPoint(x + x3 - w32, y + y5), startAngle: .pi / 2, endAngle: .pi, rx: w32, ry: hR)
		path1.addCurve(to: CGPoint(x + x3 - w32, y + y5), control1: controlPoint[0], control2: controlPoint[1])

		path1.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y4)))
		path1.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + y4)))
		path1.addLine(to: CGPoint(x: CGFloat(x + w8), y: CGFloat(y + y3)))
		path1.closeSubpath()

		let path2_sp1 = CGMutablePath()
		path2_sp1.move(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + hR)))

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x5, y + hR), framePoint2: CGPoint(x + x5 - w32, y + y1), startAngle: 0, endAngle: .pi / 2, rx: w32, ry: hR)
		path2_sp1.addCurve(to: CGPoint(x + x5 - w32, y + y1), control1: controlPoint[0], control2: controlPoint[1])

		path2_sp1.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y1)))

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x3 - w32, y + y1 + hR), framePoint2: CGPoint(x + x3, y + y1), startAngle: .pi, endAngle: (.pi / 2) * 3, rx: w32, ry: hR)
		path2_sp1.addCurve(to: CGPoint(x + x3 - w32, y + y1 + hR), control1: controlPoint[1], control2: controlPoint[0])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x3, y + y2), framePoint2: CGPoint(x + x3 - w32, y + y1 + hR), startAngle: .pi / 2, endAngle: .pi, rx: w32, ry: hR)
		path2_sp1.addCurve(to: CGPoint(x + x3, y + y2), control1: controlPoint[1], control2: controlPoint[0])

		path2_sp1.addLine(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y2)))
		path2_sp1.closeSubpath()

		let path2_sp2 = CGMutablePath()
		path2_sp2.move(to: CGPoint(x: CGFloat(x + x6), y: CGFloat(y + hR)))

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x6 + w32, y + y1), framePoint2: CGPoint(x + x6, y + hR), startAngle: .pi / 2, endAngle: .pi, rx: w32, ry: hR)
		path2_sp2.addCurve(to: CGPoint(x + x6 + w32, y + y1), control1: controlPoint[1], control2: controlPoint[0])

		path2_sp2.addLine(to: CGPoint(x: CGFloat(x + x8), y: CGFloat(y + y1)))

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x8, y + y1), framePoint2: CGPoint(x + x8 + w32, y + y1 + hR), startAngle: 3 * (.pi / 2), endAngle: 0, rx: w32, ry: hR)
		path2_sp2.addCurve(to: CGPoint(x + x8 + w32, y + y1 + hR), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x8 + w32, y + y1 + hR), framePoint2: CGPoint(x + x8, y + y2), startAngle: 0, endAngle: .pi / 2, rx: w32, ry: hR)
		path2_sp2.addCurve(to: CGPoint(x + x8, y + y2), control1: controlPoint[0], control2: controlPoint[1])

		path2_sp2.addLine(to: CGPoint(x: CGFloat(x + x6), y: CGFloat(y + y2)))
		path2_sp2.closeSubpath()

		let path3_sp1 = CGMutablePath()
		path3_sp1.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
		path3_sp1.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y)))

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x4, y), framePoint2: CGPoint(x + x4 + w32, y + hR), startAngle: 3 * (.pi / 2), endAngle: 0, rx: w32, ry: hR)
		path3_sp1.addCurve(to: CGPoint(x + x4 + w32, y + hR), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x4 + w32, y + hR), framePoint2: CGPoint(x + x4, y + y1), startAngle: 0, endAngle: .pi / 2, rx: w32, ry: hR)
		path3_sp1.addCurve(to: CGPoint(x + x4, y + y1), control1: controlPoint[0], control2: controlPoint[1])

		path3_sp1.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y1)))

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x3 - w32, y + y1 + hR), framePoint2: CGPoint(x + x3, y + y1), startAngle: .pi, endAngle: (.pi / 2) * 3, rx: w32, ry: hR)
		path3_sp1.addCurve(to: CGPoint(x + x3 - w32, y + y1 + hR), control1: controlPoint[1], control2: controlPoint[0])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x3, y + y2), framePoint2: CGPoint(x + x3 - w32, y + y1 + hR), startAngle: .pi / 2, endAngle: .pi, rx: w32, ry: hR)
		path3_sp1.addCurve(to: CGPoint(x + x3, y + y2), control1: controlPoint[1], control2: controlPoint[0])

		path3_sp1.addLine(to: CGPoint(x: CGFloat(x + x8), y: CGFloat(y + y2)))

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x8 + w32, y + y2 - hR), framePoint2: CGPoint(x + x8, y + y2), startAngle: 0, endAngle: .pi / 2, rx: w32, ry: hR)
		path3_sp1.addCurve(to: CGPoint(x + x8 + w32, y + y2 - hR), control1: controlPoint[1], control2: controlPoint[0])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x8, y + y1), framePoint2: CGPoint(x + x8 + w32, y + y2 - hR), startAngle: (.pi / 2) * 3, endAngle: 0, rx: w32, ry: hR)
		path3_sp1.addCurve(to: CGPoint(x + x8, y + y1), control1: controlPoint[1], control2: controlPoint[0])

		path3_sp1.addLine(to: CGPoint(x: CGFloat(x + x7), y: CGFloat(y + y1)))

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x7, y + y1), framePoint2: CGPoint(x + x7 - w32, y + y1 - hR), startAngle: .pi / 2, endAngle: .pi, rx: w32, ry: hR)
		path3_sp1.addCurve(to: CGPoint(x + x7 - w32, y + y1 - hR), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x7 - w32, y + y1 - hR), framePoint2: CGPoint(x + x7, y), startAngle: .pi, endAngle: (.pi / 2) * 3, rx: w32, ry: hR)
		path3_sp1.addCurve(to: CGPoint(x + x7, y), control1: controlPoint[0], control2: controlPoint[1])

		path3_sp1.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path3_sp1.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y3)))
		path3_sp1.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + y4)))
		path3_sp1.addLine(to: CGPoint(x: CGFloat(x + x9), y: CGFloat(y + y4)))
		path3_sp1.addLine(to: CGPoint(x: CGFloat(x + x9), y: CGFloat(y + y5)))

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x9, y + y5), framePoint2: CGPoint(x + x9 - w32, y + h), startAngle: 0, endAngle: .pi / 2, rx: w32, ry: hR)
		path3_sp1.addCurve(to: CGPoint(x + x9 - w32, y + h), control1: controlPoint[0], control2: controlPoint[1])

		path3_sp1.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + h)))

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x3, y + h), framePoint2: CGPoint(x + x3 - w32, y + y5), startAngle: .pi / 2, endAngle: .pi, rx: w32, ry: hR)
		path3_sp1.addCurve(to: CGPoint(x + x3 - w32, y + y5), control1: controlPoint[0], control2: controlPoint[1])

		path3_sp1.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y4)))
		path3_sp1.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + y4)))
		path3_sp1.addLine(to: CGPoint(x: CGFloat(x + w8), y: CGFloat(y + y3)))
		path3_sp1.closeSubpath()

		let path3_sp2 = CGMutablePath()
		path3_sp2.move(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + hR)))
		path3_sp2.addLine(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y2)))
		path3_sp2.move(to: CGPoint(x: CGFloat(x + x6), y: CGFloat(y + hR)))
		path3_sp2.addLine(to: CGPoint(x: CGFloat(x + x6), y: CGFloat(y + y2)))
		path3_sp2.move(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y4)))
		path3_sp2.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y6)))
		path3_sp2.move(to: CGPoint(x: CGFloat(x + x9), y: CGFloat(y + y6)))
		path3_sp2.addLine(to: CGPoint(x: CGFloat(x + x9), y: CGFloat(y + y4)))

		let pathArray = [path1, path2_sp1, path2_sp2, path3_sp1, path3_sp2]
		let pathProps = [1, 2, 2, 3, 3]
		let handles = [CGPoint(midX, y2), CGPoint(x2, 0)]
		let textFrame = CGRect(x: x + x2, y: y + y2, width: CGFloat(x9 - x2), height: CGFloat(h - y2))
		let animationFrame = frame
		let connector = [[midX, y2, 270], [w8, y3, 180], [midX, h, 90], [x1, y3, 0]]
		return PresetPathInfo(paths: pathArray, handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, pathProps: pathProps, connectors: connector)
	}

	func curvedUpRibbon(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let maxX: CGFloat = w
		let maxY: CGFloat = h
		let a1: CGFloat = modifiers[0] * maxY
		let a2: CGFloat = modifiers[1] * maxX * 0.5
		var a3: CGFloat = modifiers[2] * maxY
		let midX: CGFloat = maxX * 0.5
		let w8: CGFloat = maxX * (1.0 / 8.0)

		// MARK: Unused

		let q11: CGFloat = (1.0 - modifiers[0]) * 0.5 * maxY
		let q12: CGFloat = a1 - q11
		var val: CGFloat = q12
		if q12 < 0 {
			val = 0
		}
		a3 = limit(value: a3, minValue: val, maxValue: a1)
		let x2: CGFloat = midX - a2
		let x3: CGFloat = x2 + w8
		let x4: CGFloat = maxX - x3
		let x5: CGFloat = maxX - x2
		let x6: CGFloat = maxX - w8
		let f1: CGFloat = 4.0 * a3 / maxX
		let q1: CGFloat = x3 * x3 / maxX
		let q2: CGFloat = x3 - q1
		let u1: CGFloat = f1 * q2
		let y1: CGFloat = maxY - u1
		let cx1: CGFloat = x3 * 0.5
		let cu1: CGFloat = f1 * cx1
		let cy1: CGFloat = maxY - cu1
		let cx2: CGFloat = maxX - cx1

		let dy3: CGFloat = a1 - a3
		let q3: CGFloat = x2 * x2 / maxX
		let q4: CGFloat = x2 - q3
		let q5: CGFloat = f1 * q4
		let u3: CGFloat = q5 + dy3
		let y3: CGFloat = maxY - u3
		let q6: CGFloat = a3 + dy3 - u3
		let q7: CGFloat = q6 + a3
		let cu3: CGFloat = q7 + dy3
		let cy3: CGFloat = maxY - cu3
		let rh: CGFloat = maxY - a1
		let q8: CGFloat = a3 * (7.0 / 8.0)
		let u2: CGFloat = (q8 + rh) / 2.0
		let y2: CGFloat = maxY - u2
		let u5: CGFloat = q5 + rh
		let y5: CGFloat = maxY - u5
		let u6: CGFloat = u3 + rh
		let y6: CGFloat = maxY - u6
		let cx4: CGFloat = x2 * 0.5
		let q9: CGFloat = f1 * cx4
		let cu4: CGFloat = q9 + rh
		let cy4: CGFloat = maxY - cu4
		let cx5: CGFloat = maxX - cx4
		let cu6: CGFloat = cu3 + rh
		let cy6: CGFloat = maxY - cu6
		let u7: CGFloat = u1 + dy3
		let y7: CGFloat = maxY - u7
		let cu7: CGFloat = a1 * a1 / u7
		let cy7: CGFloat = maxY - cu7

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y + maxY)))

		var cubicPoints = toCubicControlPoints(p1: CGPoint(0, maxY), cx1: cx1, cy1: cy1, p2: CGPoint(x3, y1))
		path1.addCurve(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y1)), control1: CGPoint(x: CGFloat(x + cubicPoints[0]), y: CGFloat(y + cubicPoints[1])), control2: CGPoint(x: CGFloat(x + cubicPoints[2]), y: CGFloat(y + cubicPoints[3])))
		path1.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y3)))
		cubicPoints = toCubicControlPoints(p1: CGPoint(x2, y3), cx1: midX, cy1: cy3, p2: CGPoint(x5, y3))
		path1.addCurve(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y3)), control1: CGPoint(x: CGFloat(x + cubicPoints[0]), y: CGFloat(y + cubicPoints[1])), control2: CGPoint(x: CGFloat(x + cubicPoints[2]), y: CGFloat(y + cubicPoints[3])))

		path1.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y1)))
		cubicPoints = toCubicControlPoints(p1: CGPoint(x4, y1), cx1: cx2, cy1: cy1, p2: CGPoint(maxX, maxY))
		path1.addCurve(to: CGPoint(x: CGFloat(x + maxX), y: CGFloat(y + maxY)), control1: CGPoint(x: CGFloat(x + cubicPoints[0]), y: CGFloat(y + cubicPoints[1])), control2: CGPoint(x: CGFloat(x + cubicPoints[2]), y: CGFloat(y + cubicPoints[3])))
		path1.addLine(to: CGPoint(x: CGFloat(x + x6), y: CGFloat(y + y2)))
		path1.addLine(to: CGPoint(x: CGFloat(x + maxX), y: CGFloat(y + a1)))
		cubicPoints = toCubicControlPoints(p1: CGPoint(maxX, a1), cx1: cx5, cy1: cy4, p2: CGPoint(x5, y5))
		path1.addCurve(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y5)), control1: CGPoint(x: CGFloat(x + cubicPoints[0]), y: CGFloat(y + cubicPoints[1])), control2: CGPoint(x: CGFloat(x + cubicPoints[2]), y: CGFloat(y + cubicPoints[3])))
		path1.addLine(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y6)))
		cubicPoints = toCubicControlPoints(p1: CGPoint(x5, y6), cx1: midX, cy1: cy6, p2: CGPoint(x2, y6))
		path1.addCurve(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y6)), control1: CGPoint(x: CGFloat(x + cubicPoints[0]), y: CGFloat(y + cubicPoints[1])), control2: CGPoint(x: CGFloat(x + cubicPoints[2]), y: CGFloat(y + cubicPoints[3])))

		path1.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y5)))
		cubicPoints = toCubicControlPoints(p1: CGPoint(x2, y5), cx1: cx4, cy1: cy4, p2: CGPoint(0, a1))
		path1.addCurve(to: CGPoint(x: CGFloat(x), y: CGFloat(y + a1)), control1: CGPoint(x: CGFloat(x + cubicPoints[0]), y: CGFloat(y + cubicPoints[1])), control2: CGPoint(x: CGFloat(x + cubicPoints[2]), y: CGFloat(y + cubicPoints[3])))
		path1.addLine(to: CGPoint(x: CGFloat(x + w8), y: CGFloat(y + y2)))
		path1.closeSubpath()

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y7)))
		path2.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y1)))
		path2.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y3)))
		cubicPoints = toCubicControlPoints(p1: CGPoint(x2, y3), cx1: midX, cy1: cy3, p2: CGPoint(x5, y3))
		path2.addCurve(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y3)), control1: CGPoint(x: CGFloat(x + cubicPoints[0]), y: CGFloat(y + cubicPoints[1])), control2: CGPoint(x: CGFloat(x + cubicPoints[2]), y: CGFloat(y + cubicPoints[3])))
		path2.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y1)))
		path2.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y7)))
		cubicPoints = toCubicControlPoints(p1: CGPoint(x4, y1), cx1: midX, cy1: cy7, p2: CGPoint(x3, y7))
		path2.addCurve(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y7)), control1: CGPoint(x: CGFloat(x + cubicPoints[0]), y: CGFloat(y + cubicPoints[1])), control2: CGPoint(x: CGFloat(x + cubicPoints[2]), y: CGFloat(y + cubicPoints[3])))
		path2.closeSubpath()

		let path3 = CGMutablePath()
		path3.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y + maxY)))
		cubicPoints = toCubicControlPoints(p1: CGPoint(0, maxY), cx1: cx1, cy1: cy1, p2: CGPoint(x3, y1))
		path3.addCurve(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y1)), control1: CGPoint(x: CGFloat(x + cubicPoints[0]), y: CGFloat(y + cubicPoints[1])), control2: CGPoint(x: CGFloat(x + cubicPoints[2]), y: CGFloat(y + cubicPoints[3])))
		path3.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y3)))
		cubicPoints = toCubicControlPoints(p1: CGPoint(x2, y3), cx1: midX, cy1: cy3, p2: CGPoint(x5, y3))
		path3.addCurve(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y3)), control1: CGPoint(x: CGFloat(x + cubicPoints[0]), y: CGFloat(y + cubicPoints[1])), control2: CGPoint(x: CGFloat(x + cubicPoints[2]), y: CGFloat(y + cubicPoints[3])))
		path3.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y1)))
		cubicPoints = toCubicControlPoints(p1: CGPoint(x4, y1), cx1: cx2, cy1: cy1, p2: CGPoint(maxX, maxY))
		path3.addCurve(to: CGPoint(x: CGFloat(x + maxX), y: CGFloat(y + maxY)), control1: CGPoint(x: CGFloat(x + cubicPoints[0]), y: CGFloat(y + cubicPoints[1])), control2: CGPoint(x: CGFloat(x + cubicPoints[2]), y: CGFloat(y + cubicPoints[3])))
		path3.addLine(to: CGPoint(x: CGFloat(x + x6), y: CGFloat(y + y2)))
		path3.addLine(to: CGPoint(x: CGFloat(x + maxX), y: CGFloat(y + a1)))
		cubicPoints = toCubicControlPoints(p1: CGPoint(maxX, a1), cx1: cx5, cy1: cy4, p2: CGPoint(x5, y5))
		path3.addCurve(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y5)), control1: CGPoint(x: CGFloat(x + cubicPoints[0]), y: CGFloat(y + cubicPoints[1])), control2: CGPoint(x: CGFloat(x + cubicPoints[2]), y: CGFloat(y + cubicPoints[3])))

		path3.addLine(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y6)))
		cubicPoints = toCubicControlPoints(p1: CGPoint(x5, y6), cx1: midX, cy1: cy6, p2: CGPoint(x2, y6))
		path3.addCurve(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y6)), control1: CGPoint(x: CGFloat(x + cubicPoints[0]), y: CGFloat(y + cubicPoints[1])), control2: CGPoint(x: CGFloat(x + cubicPoints[2]), y: CGFloat(y + cubicPoints[3])))
		path3.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y5)))
		cubicPoints = toCubicControlPoints(p1: CGPoint(x2, y5), cx1: cx4, cy1: cy4, p2: CGPoint(0, a1))
		path3.addCurve(to: CGPoint(x: CGFloat(x), y: CGFloat(y + a1)), control1: CGPoint(x: CGFloat(x + cubicPoints[0]), y: CGFloat(y + cubicPoints[1])), control2: CGPoint(x: CGFloat(x + cubicPoints[2]), y: CGFloat(y + cubicPoints[3])))
		path3.addLine(to: CGPoint(x: CGFloat(x + w8), y: CGFloat(y + y2)))
		path3.closeSubpath()
		path3.move(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y7)))
		path3.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y1)))
		path3.move(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y1)))
		path3.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y7)))
		path3.move(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y3)))
		path3.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y5)))
		path3.move(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y5)))
		path3.addLine(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y3)))

		let pathArray = [path1, path2, path3]
		let handles = [CGPoint(midX, rh), CGPoint(x2, 0), CGPoint(0, a3)]
		let textFrame = CGRect(x: x + x2, y: y + y6, width: CGFloat(x5 - x2), height: CGFloat(rh - y6))
		let animationFrame = frame
		let connector = [[midX, 0, 270], [w8, y2, 180], [midX, rh, 90], [x6, y2, 0]]
		return PresetPathInfo(paths: pathArray, handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func curvedDownRibbon(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let maxX: CGFloat = w
		let maxY: CGFloat = h
		let a1: CGFloat = modifiers[0] * maxY
		let a2: CGFloat = modifiers[1] * maxX * 0.5
		var a3: CGFloat = modifiers[2] * maxY
		let midX: CGFloat = maxX * 0.5
		let w8: CGFloat = maxX * (1.0 / 8.0)

		// MARK: Unused

		let q11: CGFloat = (1.0 - modifiers[0]) * 0.5 * maxY
		let q12: CGFloat = a1 - q11
		var val: CGFloat = q12
		if q12 < 0 {
			val = 0
		}
		a3 = limit(value: a3, minValue: val, maxValue: a1)

		let x2: CGFloat = midX - a2
		let x3: CGFloat = x2 + w8
		let x4: CGFloat = maxX - x3
		let x5: CGFloat = maxX - x2
		let x6: CGFloat = maxX - w8
		let f1: CGFloat = 4 * a3 / maxX
		let q1: CGFloat = x3 * x3 / maxX
		let q2: CGFloat = x3 - q1
		let y1: CGFloat = f1 * q2
		let cx1: CGFloat = x3 * 0.5
		let cy1: CGFloat = f1 * cx1
		let cx2: CGFloat = maxX - cx1
		let dy3: CGFloat = a1 - a3
		let q3: CGFloat = x2 * x2 / maxX
		let q4: CGFloat = x2 - q3
		let q5: CGFloat = f1 * q4
		let y3: CGFloat = q5 + dy3
		let q6: CGFloat = a3 + dy3 - y3
		let q7: CGFloat = q6 + a3
		let cy3: CGFloat = q7 + dy3
		let rh: CGFloat = maxY - a1
		let q8: CGFloat = a3 * (7.0 / 8.0)
		let y2: CGFloat = (q8 + rh) / 2
		let y5: CGFloat = q5 + rh
		let y6: CGFloat = y3 + rh
		let cx4: CGFloat = x2 * 0.5
		let q9: CGFloat = f1 * cx4
		let cy4: CGFloat = q9 + rh
		let cx5: CGFloat = maxX - cx4
		let cy6: CGFloat = cy3 + rh
		let y7: CGFloat = y1 + dy3
		let cy7: CGFloat = a1 * a1 / y7
		let y8: CGFloat = h - a3

		// MARK: Unused

//		let y8: CGFloat = maxY - a3

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
		var cubicPoints = toCubicControlPoints(p1: .zero, cx1: cx1, cy1: cy1, p2: CGPoint(x3, y1))
		path1.addCurve(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y1)), control1: CGPoint(x: CGFloat(x + cubicPoints[0]), y: CGFloat(y + cubicPoints[1])), control2: CGPoint(x: CGFloat(x + cubicPoints[2]), y: CGFloat(y + cubicPoints[3])))
		path1.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y3)))
		cubicPoints = toCubicControlPoints(p1: CGPoint(x2, y3), cx1: midX, cy1: cy3, p2: CGPoint(x5, y3))
		path1.addCurve(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y3)), control1: CGPoint(x: CGFloat(x + cubicPoints[0]), y: CGFloat(y + cubicPoints[1])), control2: CGPoint(x: CGFloat(x + cubicPoints[2]), y: CGFloat(y + cubicPoints[3])))
		path1.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y1)))
		cubicPoints = toCubicControlPoints(p1: CGPoint(x4, y1), cx1: cx2, cy1: cy1, p2: CGPoint(maxX, 0))
		path1.addCurve(to: CGPoint(x: CGFloat(x + maxX), y: CGFloat(y)), control1: CGPoint(x: CGFloat(x + cubicPoints[0]), y: CGFloat(y + cubicPoints[1])), control2: CGPoint(x: CGFloat(x + cubicPoints[2]), y: CGFloat(y + cubicPoints[3])))

		path1.addLine(to: CGPoint(x: CGFloat(x + x6), y: CGFloat(y + y2)))
		path1.addLine(to: CGPoint(x: CGFloat(x + maxX), y: CGFloat(y + rh)))
		cubicPoints = toCubicControlPoints(p1: CGPoint(maxX, rh), cx1: cx5, cy1: cy4, p2: CGPoint(x5, y5))
		path1.addCurve(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y5)), control1: CGPoint(x: CGFloat(x + cubicPoints[0]), y: CGFloat(y + cubicPoints[1])), control2: CGPoint(x: CGFloat(x + cubicPoints[2]), y: CGFloat(y + cubicPoints[3])))
		path1.addLine(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y6)))
		cubicPoints = toCubicControlPoints(p1: CGPoint(x5, y6), cx1: midX, cy1: cy6, p2: CGPoint(x2, y6))
		path1.addCurve(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y6)), control1: CGPoint(x: CGFloat(x + cubicPoints[0]), y: CGFloat(y + cubicPoints[1])), control2: CGPoint(x: CGFloat(x + cubicPoints[2]), y: CGFloat(y + cubicPoints[3])))

		path1.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y5)))
		cubicPoints = toCubicControlPoints(p1: CGPoint(x2, y5), cx1: cx4, cy1: cy4, p2: CGPoint(0, rh))
		path1.addCurve(to: CGPoint(x: CGFloat(x), y: CGFloat(y + rh)), control1: CGPoint(x: CGFloat(x + cubicPoints[0]), y: CGFloat(y + cubicPoints[1])), control2: CGPoint(x: CGFloat(x + cubicPoints[2]), y: CGFloat(y + cubicPoints[3])))
		path1.addLine(to: CGPoint(x: CGFloat(x + w8), y: CGFloat(y + y2)))
		path1.closeSubpath()

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y7)))
		path2.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y1)))
		path2.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y3)))
		cubicPoints = toCubicControlPoints(p1: CGPoint(x2, y3), cx1: midX, cy1: cy3, p2: CGPoint(x5, y3))
		path2.addCurve(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y3)), control1: CGPoint(x: CGFloat(x + cubicPoints[0]), y: CGFloat(y + cubicPoints[1])), control2: CGPoint(x: CGFloat(x + cubicPoints[2]), y: CGFloat(y + cubicPoints[3])))
		path2.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y1)))
		path2.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y7)))
		cubicPoints = toCubicControlPoints(p1: CGPoint(x4, y7), cx1: midX, cy1: cy7, p2: CGPoint(x3, y7))
		path2.addCurve(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y7)), control1: CGPoint(x: CGFloat(x + cubicPoints[0]), y: CGFloat(y + cubicPoints[1])), control2: CGPoint(x: CGFloat(x + cubicPoints[2]), y: CGFloat(y + cubicPoints[3])))
		path2.closeSubpath()

		let path3 = CGMutablePath()
		path3.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))

		cubicPoints = toCubicControlPoints(p1: .zero, cx1: cx1, cy1: cy1, p2: CGPoint(x3, y1))
		path3.addCurve(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y1)), control1: CGPoint(x: CGFloat(x + cubicPoints[0]), y: CGFloat(y + cubicPoints[1])), control2: CGPoint(x: CGFloat(x + cubicPoints[2]), y: CGFloat(y + cubicPoints[3])))
		path3.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y3)))
		cubicPoints = toCubicControlPoints(p1: CGPoint(x2, y3), cx1: midX, cy1: cy3, p2: CGPoint(x5, y3))
		path3.addCurve(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y3)), control1: CGPoint(x: CGFloat(x + cubicPoints[0]), y: CGFloat(y + cubicPoints[1])), control2: CGPoint(x: CGFloat(x + cubicPoints[2]), y: CGFloat(y + cubicPoints[3])))
		path3.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y1)))
		cubicPoints = toCubicControlPoints(p1: CGPoint(x4, y1), cx1: cx2, cy1: cy1, p2: CGPoint(maxX, 0))
		path3.addCurve(to: CGPoint(x: CGFloat(x + maxX), y: CGFloat(y)), control1: CGPoint(x: CGFloat(x + cubicPoints[0]), y: CGFloat(y + cubicPoints[1])), control2: CGPoint(x: CGFloat(x + cubicPoints[2]), y: CGFloat(y + cubicPoints[3])))
		path3.addLine(to: CGPoint(x: CGFloat(x + x6), y: CGFloat(y + y2)))
		path3.addLine(to: CGPoint(x: CGFloat(x + maxX), y: CGFloat(y + rh)))
		cubicPoints = toCubicControlPoints(p1: CGPoint(maxX, rh), cx1: cx5, cy1: cy4, p2: CGPoint(x5, y5))
		path3.addCurve(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y5)), control1: CGPoint(x: CGFloat(x + cubicPoints[0]), y: CGFloat(y + cubicPoints[1])), control2: CGPoint(x: CGFloat(x + cubicPoints[2]), y: CGFloat(y + cubicPoints[3])))

		path3.addLine(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y6)))
		cubicPoints = toCubicControlPoints(p1: CGPoint(x5, y6), cx1: midX, cy1: cy6, p2: CGPoint(x2, y6))
		path3.addCurve(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y6)), control1: CGPoint(x: CGFloat(x + cubicPoints[0]), y: CGFloat(y + cubicPoints[1])), control2: CGPoint(x: CGFloat(x + cubicPoints[2]), y: CGFloat(y + cubicPoints[3])))
		path3.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y5)))
		cubicPoints = toCubicControlPoints(p1: CGPoint(x2, y5), cx1: cx4, cy1: cy4, p2: CGPoint(0, rh))
		path3.addCurve(to: CGPoint(x: CGFloat(x), y: CGFloat(y + rh)), control1: CGPoint(x: CGFloat(x + cubicPoints[0]), y: CGFloat(y + cubicPoints[1])), control2: CGPoint(x: CGFloat(x + cubicPoints[2]), y: CGFloat(y + cubicPoints[3])))
		path3.addLine(to: CGPoint(x: CGFloat(x + w8), y: CGFloat(y + y2)))
		path3.closeSubpath()
		path3.move(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y7)))
		path3.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y1)))
		path3.move(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y1)))
		path3.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y7)))
		path3.move(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y3)))
		path3.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y5)))
		path3.move(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y5)))
		path3.addLine(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y3)))

		let pathArray = [path1, path2, path3]
		let handles = [CGPoint(midX, a1), CGPoint(x2, h), CGPoint(0, y8)]
		let textFrame = CGRect(x: x + x2, y: y + q1, width: CGFloat(x5 - x2), height: CGFloat(y6 - q1))
		let animationFrame = frame
		let connector = [[midX, q1, 270], [w8, y2, 180], [midX, h, 90], [x6, y2, 0]]
		return PresetPathInfo(paths: pathArray, handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func verticalScroll(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let ch: CGFloat = getCoordinates(modifiers[0], Width: w, Height: h, Percent: 0.5, Type: "z")
		let ch2: CGFloat = ch * 0.5
		let ch4: CGFloat = ch * 0.25
		let x1: CGFloat = ch + ch2
		let x2: CGFloat = ch + ch
		let x3: CGFloat = w - ch
		let x4: CGFloat = w - ch2
		let x5: CGFloat = x3 - ch2
		let y1: CGFloat = h - ch
		let y2: CGFloat = h - ch2

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x: CGFloat(x + ch2), y: CGFloat(y + h)))
		path1.addArc(center: CGPoint(x: CGFloat(x + ch2), y: CGFloat(y + h - ch2)), radius: ch - ch2, startAngle: .pi / 2, endAngle: 0, clockwise: true)
		path1.addLine(to: CGPoint(x: CGFloat(x + ch2), y: CGFloat(y + y2)))
		path1.addArc(center: CGPoint(x: CGFloat(x + ch2), y: CGFloat(y + y2 - ch4)), radius: ch4, startAngle: .pi / 2, endAngle: 3 * (.pi / 2), clockwise: false)
		path1.addLine(to: CGPoint(x: CGFloat(x + ch), y: CGFloat(y + y1)))
		path1.addLine(to: CGPoint(x: CGFloat(x + ch), y: CGFloat(y + ch2)))
		path1.addArc(center: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + ch2)), radius: ch2, startAngle: .pi, endAngle: 3 * (.pi / 2), clockwise: false)
		path1.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y)))
		path1.addArc(center: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + ch2)), radius: ch2, startAngle: 3 * (.pi / 2), endAngle: .pi / 2, clockwise: false)
		path1.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + ch)))
		path1.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y2)))
		path1.addArc(center: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y2)), radius: h - y2, startAngle: 0, endAngle: .pi / 2, clockwise: false)
		path1.closeSubpath()

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + ch2)))
		path2.addArc(center: CGPoint(x: CGFloat(x + x2 - ch2), y: CGFloat(y + ch2)), radius: ch - ch2, startAngle: 0, endAngle: .pi / 2, clockwise: false)
		path2.addArc(center: CGPoint(x: CGFloat(x + x2 - ch2), y: CGFloat(y + ch - ch4)), radius: ch4, startAngle: .pi / 2, endAngle: 3 * (.pi / 2), clockwise: false)
		path2.closeSubpath()

		path2.move(to: CGPoint(x: CGFloat(x + ch), y: CGFloat(y + y2)))
		path2.addArc(center: CGPoint(x: CGFloat(x + ch - ch2), y: CGFloat(y + y2)), radius: ch2, startAngle: 0, endAngle: 3 * (.pi / 2), clockwise: false)
		path2.addArc(center: CGPoint(x: CGFloat(x + ch2), y: CGFloat(y + y2 - ch4)), radius: ch4, startAngle: 3 * (.pi / 2), endAngle: .pi / 2, clockwise: false)
		path2.closeSubpath()

		let path3 = CGMutablePath()
		path3.move(to: CGPoint(x: CGFloat(x + ch), y: CGFloat(y + y1)))
		path3.addLine(to: CGPoint(x: CGFloat(x + ch), y: CGFloat(y + ch2)))
		path3.addArc(center: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + ch2)), radius: ch2, startAngle: .pi, endAngle: 3 * (.pi / 2), clockwise: false)
		path3.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y)))
		path3.addArc(center: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + ch2)), radius: ch2, startAngle: 3 * (.pi / 2), endAngle: .pi / 2, clockwise: false)
		path3.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + ch)))
		path3.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y2)))
		path3.addArc(center: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y2)), radius: h - y2, startAngle: 0, endAngle: .pi / 2, clockwise: false)

		path3.addLine(to: CGPoint(x: CGFloat(x + ch2), y: CGFloat(y + h)))
		path3.addArc(center: CGPoint(x: CGFloat(x + ch2), y: CGFloat(y + h - ch2)), radius: ch2, startAngle: .pi / 2, endAngle: 3 * (.pi / 2), clockwise: false)
		path3.closeSubpath()

		path3.move(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y)))
		path3.addArc(center: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + ch2)), radius: ch2, startAngle: 3 * (.pi / 2), endAngle: .pi / 2, clockwise: false)
		path3.addArc(center: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + ch - ch4)), radius: ch4, startAngle: .pi / 2, endAngle: 3 * (.pi / 2), clockwise: false)
		path3.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + ch2)))

		path3.move(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + ch)))
		path3.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + ch)))

		path3.move(to: CGPoint(x: CGFloat(x + ch2), y: CGFloat(y + y1)))
		path3.addArc(center: CGPoint(x: CGFloat(x + ch2), y: CGFloat(y + y1 + ch4)), radius: ch4, startAngle: 3 * (.pi / 2), endAngle: .pi / 2, clockwise: false)
		path3.addLine(to: CGPoint(x: CGFloat(x + ch), y: CGFloat(y + y2)))

		path3.move(to: CGPoint(x: CGFloat(x + ch2), y: CGFloat(y + h)))
		path3.addArc(center: CGPoint(x: CGFloat(x + ch2), y: CGFloat(y + h - ch2)), radius: ch - ch2, startAngle: .pi / 2, endAngle: 0, clockwise: true)
		path3.addLine(to: CGPoint(x: CGFloat(x + ch), y: CGFloat(y + y1)))

		let midX = w * 0.5
		let midY = h * 0.5

		let pathArray = [path1, path2, path3]
		let handles = [CGPoint(0, ch)]
		let textFrame = CGRect(x: x + ch, y: y + ch, width: CGFloat(x3 - ch), height: CGFloat(y2 - ch))
		let animationFrame = frame
		let connector = [[midX, 0, 270], [ch, midY, 0], [midX, h, 90], [x3, midY, 180]]
		return PresetPathInfo(paths: pathArray, handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func horizontalScroll(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let ch: CGFloat = getCoordinates(modifiers[0], Width: w, Height: h, Percent: 0.5, Type: "z")
		let ch2: CGFloat = ch * 0.5
		let ch4: CGFloat = ch * 0.25
		let y3: CGFloat = ch + ch2
		let y4: CGFloat = ch + ch
		let y6: CGFloat = h - ch
		let y7: CGFloat = h - ch2
		let y5: CGFloat = y6 - ch2
		let x3: CGFloat = w - ch
		let x4: CGFloat = w - ch2

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + ch2)))
		path1.addArc(center: CGPoint(x + w - (ch - ch2), y + ch2), radius: ch - ch2, startAngle: 0, endAngle: .pi / 2, clockwise: false)
		// path1.addLine(to: CGPoint(x + x4, y + ch2))
		path1.addArc(center: CGPoint(x + (x4 - ch4), y + ch2), radius: ch4, startAngle: 0, endAngle: .pi, clockwise: false)
		path1.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + ch)))
		path1.addLine(to: CGPoint(x: CGFloat(x + ch2), y: CGFloat(y + ch)))
		path1.addArc(center: CGPoint(x: CGFloat(x + ch2), y: CGFloat(y + y3)), radius: y3 - ch, startAngle: 3 * (.pi / 2), endAngle: .pi, clockwise: true)
		path1.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + y7)))
		path1.addArc(center: CGPoint(x: CGFloat(x + ch2), y: CGFloat(y + y7)), radius: ch2, startAngle: .pi, endAngle: 0, clockwise: true)
		path1.addLine(to: CGPoint(x: CGFloat(x + ch), y: CGFloat(y + y6)))
		path1.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y6)))
		path1.addArc(center: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y5)), radius: w - x4, startAngle: .pi / 2, endAngle: 0, clockwise: true)
		path1.closeSubpath()

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x: CGFloat(x + ch2), y: CGFloat(y + y4)))
		path2.addArc(center: CGPoint(x: CGFloat(x + ch2), y: CGFloat(y + y4 - ch2)), radius: ch2, startAngle: .pi / 2, endAngle: 0, clockwise: true)
		path2.addArc(center: CGPoint(x: CGFloat(x + ch - ch4), y: CGFloat(y + y4 - ch2)), radius: ch4, startAngle: 0, endAngle: .pi, clockwise: true)
		path2.closeSubpath()
		path2.move(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + ch)))
		path2.addArc(center: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + ch2)), radius: ch2, startAngle: .pi / 2, endAngle: .pi, clockwise: true)
		path2.addArc(center: CGPoint(x: CGFloat(x + x4 - ch4), y: CGFloat(y + ch2)), radius: ch4, startAngle: .pi, endAngle: 0, clockwise: true)
		path2.closeSubpath()

		let path3 = CGMutablePath()
		path3.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y + y3)))
		path3.addArc(center: CGPoint(x: CGFloat(x + ch2), y: CGFloat(y + y3)), radius: ch2, startAngle: .pi, endAngle: 3 * (.pi / 2), clockwise: false)
		path3.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + ch)))
		path3.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + ch2)))
		path3.addArc(center: CGPoint(x: CGFloat(x + x3 + ch2), y: CGFloat(y + ch2)), radius: ch2, startAngle: .pi, endAngle: 0, clockwise: false)
		path3.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + y5)))
		path3.addArc(center: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y5)), radius: w - x4, startAngle: 0, endAngle: .pi / 2, clockwise: false)
		path3.addLine(to: CGPoint(x: CGFloat(x + ch), y: CGFloat(y + y6)))
		path3.addLine(to: CGPoint(x: CGFloat(x + ch), y: CGFloat(y + y7)))
		path3.addArc(center: CGPoint(x: CGFloat(x + ch - ch2), y: CGFloat(y + y7)), radius: ch2, startAngle: 0, endAngle: .pi, clockwise: false)
		path3.closeSubpath()

		path3.move(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + ch)))
		path3.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + ch)))
		path3.addArc(center: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + ch2)), radius: ch - ch2, startAngle: .pi / 2, endAngle: 0, clockwise: true)
		path3.move(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + ch)))
		path3.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + ch2)))
		path3.addArc(center: CGPoint(x: CGFloat(x + x4 - ch4), y: CGFloat(y + ch2)), radius: ch4, startAngle: 0, endAngle: .pi, clockwise: false)

		path3.move(to: CGPoint(x: CGFloat(x + ch2), y: CGFloat(y + y4)))
		path3.addLine(to: CGPoint(x: CGFloat(x + ch2), y: CGFloat(y + y3)))
		path3.addArc(center: CGPoint(x: CGFloat(x + ch2 + ch4), y: CGFloat(y + y3)), radius: ch4, startAngle: .pi, endAngle: 0, clockwise: false)

		path3.addArc(center: CGPoint(x: CGFloat(x + ch - ch2), y: CGFloat(y + y3)), radius: ch2, startAngle: 0, endAngle: .pi, clockwise: false)
		path3.move(to: CGPoint(x: CGFloat(x + ch), y: CGFloat(y + y3)))
		path3.addLine(to: CGPoint(x: CGFloat(x + ch), y: CGFloat(y + y6)))

		let midX = w * 0.5
		let midY = h * 0.5

		let pathArray = [path1, path2, path3]
		let handles = [CGPoint(ch, 0)]
		let textFrame = CGRect(x: x + ch, y: y + ch, width: CGFloat(x4 - ch), height: CGFloat(y6 - ch))
		let animationFrame = frame
		let connector = [[midX, ch, 90], [0, midY, 180], [midX, y6, 270], [w, midY, 0]]
		return PresetPathInfo(paths: pathArray, handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func wave(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let y1: CGFloat = modifiers[0] * h
		let dy2: CGFloat = y1 * 10.0 / 3.0
		let y2: CGFloat = y1 - dy2
		let y3: CGFloat = y1 + dy2
		let y4: CGFloat = h - y1
		let y5: CGFloat = y4 - dy2
		let y6: CGFloat = y4 + dy2
		let a2: CGFloat = modifiers[1]
		let dx1: CGFloat = a2 * w
		let of2: CGFloat = dx1 * 2
		let x1 = abs(dx1)

		let dx2: CGFloat = ifElse(First: of2, Second: 0, Third: of2)
		let x2: CGFloat = 0 - dx2

		let dx5: CGFloat = ifElse(First: of2, Second: of2, Third: 0)
		let x5: CGFloat = w - dx5
		let dx3: CGFloat = (dx2 + x5) / 3.0
		let x3: CGFloat = x2 + dx3
		let x4: CGFloat = (x3 + x5) * 0.5
		let x6: CGFloat = dx5
		let x10: CGFloat = w + dx2
		let x7: CGFloat = x6 + dx3
		let x8: CGFloat = (x7 + x10) * 0.5
		let x9: CGFloat = w - x1
		let midX: CGFloat = w * 0.5
		let midY: CGFloat = h * 0.5
		let xAdj: CGFloat = midX + dx1

		let path = CGMutablePath()
		path.move(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y1)))
		path.addCurve(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y1)), control1: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y2)), control2: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y3)))
		path.addLine(to: CGPoint(x: CGFloat(x + x10), y: CGFloat(y + y4)))
		path.addCurve(to: CGPoint(x: CGFloat(x + x6), y: CGFloat(y + y4)), control1: CGPoint(x: CGFloat(x + x8), y: CGFloat(y + y6)), control2: CGPoint(x: CGFloat(x + x7), y: CGFloat(y + y5)))
		path.closeSubpath()

		let xAdj2: CGFloat = midX - dx1
		let l: CGFloat = (x2 > x6) ? x2 : x6
		let r: CGFloat = (x5 < x10) ? x5 : x10
		let t: CGFloat = y1 * 2
		let b: CGFloat = h - t

		let handles = [CGPoint(0, y1), CGPoint(xAdj, h)]
		let textFrame = CGRect(x: x + l, y: y + t, width: CGFloat(r - l), height: CGFloat(b - t))
		let animationFrame = frame
		let connector = [[xAdj2, y1, 90], [x1, midY, 180], [xAdj, y4, 270], [x9, midY, 0]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func doubleWave(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let y1: CGFloat = h * modifiers[0]
		let dy2: CGFloat = y1 * (10.0 / 3.0)
		let y2: CGFloat = y1 - dy2
		let y3: CGFloat = y1 + dy2
		let y4: CGFloat = h - y1
		let y5: CGFloat = y4 - dy2
		let y6: CGFloat = y4 + dy2
		let a2: CGFloat = modifiers[1]
		let dx1: CGFloat = a2 * w
		let of2: CGFloat = dx1 * 2
		let x1 = abs(dx1)

		let dx2: CGFloat = ifElse(First: of2, Second: 0, Third: of2)
		let x2: CGFloat = 0 - dx2
		let dx8: CGFloat = ifElse(First: of2, Second: of2, Third: 0)
		let x8: CGFloat = w - dx8
		let dx3: CGFloat = (dx2 + x8) / 6.0
		let x3: CGFloat = x2 + dx3
		let dx4: CGFloat = (dx2 + x8) / 3.0
		let x4: CGFloat = x2 + dx4
		let x5: CGFloat = (x2 + x8) / 2.0
		let x6: CGFloat = x5 + dx3
		let x7: CGFloat = (x6 + x8) / 2.0
		let x9: CGFloat = dx8
		let x15: CGFloat = w + dx2
		let x10: CGFloat = x9 + dx3
		let x11: CGFloat = x9 + dx4
		let x12: CGFloat = (x9 + x15) / 2.0
		let x13: CGFloat = x12 + dx3
		let x14: CGFloat = (x13 + x15) / 2.0
		let x16 = w - x
		let midX: CGFloat = w * 0.5
		let midY: CGFloat = h * 0.5
		let xAdj: CGFloat = midX + dx1

		let path = CGMutablePath()
		path.move(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y1)))
		path.addCurve(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y1)), control1: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y2)), control2: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y3)))
		path.addCurve(to: CGPoint(x: CGFloat(x + x8), y: CGFloat(y + y1)), control1: CGPoint(x: CGFloat(x + x6), y: CGFloat(y + y2)), control2: CGPoint(x: CGFloat(x + x7), y: CGFloat(y + y3)))
		path.addLine(to: CGPoint(x: CGFloat(x + x15), y: CGFloat(y + y4)))
		path.addCurve(to: CGPoint(x: CGFloat(x + x12), y: CGFloat(y + y4)), control1: CGPoint(x: CGFloat(x + x14), y: CGFloat(y + y6)), control2: CGPoint(x: CGFloat(x + x13), y: CGFloat(y + y5)))
		path.addCurve(to: CGPoint(x: CGFloat(x + x9), y: CGFloat(y + y4)), control1: CGPoint(x: CGFloat(x + x11), y: CGFloat(y + y6)), control2: CGPoint(x: CGFloat(x + x10), y: CGFloat(y + y5)))
		path.closeSubpath()

		let l: CGFloat = (x2 > x9) ? x2 : x9
		let r: CGFloat = (x8 < x15) ? x8 : x15
		let t: CGFloat = y1 * 2
		let b: CGFloat = h - t

		// MARK: Unused

//		let midY: CGFloat = (y + h) * 0.5

		let handles = [CGPoint(0, y1), CGPoint(xAdj, h)]
		let textFrame = CGRect(x: x + l, y: y + t, width: CGFloat(r - l), height: CGFloat(b - t))
		let animationFrame = frame
		let connector = [[x12, y1, 90], [x1, midY, 180], [x5, y4, 270], [x16, midY, 0]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}
}

// swiftlint:enable file_length function_body_length
