//
//  Blur+Draw.swift
//  Painter
//
//  Created by Ramasamy S I on 18/05/18.
//  Copyright © 2018 Zoho Corporation Pvt. Ltd. All rights reserved.
//

#if !os(watchOS)
import CoreGraphics
import CoreImage
import Foundation
import Proto

extension Blur {
	public struct BlurImage {
		let cgImage: CGImage
		let imageRect: CGRect
	}

	static var cicontext = CIContext(options: convertToOptionalCIContextOptionDictionary(
		[convertFromCIContextOption(CIContextOption.useSoftwareRenderer): false]))

	func draw(withContext blurContext: CGContext, inRect transformRect: CGRect) -> BlurImage? {
		var blurImage: BlurImage?
		switch self.type {
		case .gaussian:
			blurImage = self.drawGaussianBlur(forContext: blurContext, inRect: transformRect)
		case .unknownType:
			break
		case .box:
			blurImage = self.drawBoxBlur(forContext: blurContext, inRect: transformRect)
		case .disc:
			blurImage = self.drawDiscBlur(forContext: blurContext, inRect: transformRect)
		case .motion:
			blurImage = self.drawMotionBlur(forContext: blurContext, inRect: transformRect)
		case .zoom:
			blurImage = self.drawZoomBlur(forContext: blurContext, inRect: transformRect)
		case .masked:
			blurImage = self.drawMaskBlur(forContext: blurContext, inRect: transformRect)
		}
		return blurImage
	}

	func drawGaussianBlur(forContext blurContext: CGContext, inRect transformRect: CGRect) -> BlurImage? {
		guard let cgimage = blurContext.makeImage() else {
			return nil
		}
		guard let filter = CIFilter(name: "CIGaussianBlur") else {
			assertionFailure()
			return nil
		}
		filter.setValue(NSNumber(value: self.gaussian.radius), forKey: "inputRadius")
		let ciimage = CIImage(cgImage: cgimage)
		filter.setValue(ciimage, forKey: "inputImage")
		guard let result = filter.outputImage else {
			assertionFailure()
			return nil
		}
		guard let finalcgimage = Blur.cicontext.createCGImage(result, from: result.extent) else {
			assertionFailure("Unable to create CGImage from context.")
			return nil
		}
		var finalRect = result.extent
		finalRect.center = transformRect.center

		return BlurImage(cgImage: finalcgimage, imageRect: finalRect)
	}

	func drawBoxBlur(forContext blurContext: CGContext, inRect transformRect: CGRect) -> BlurImage? {
		guard let cgimage = blurContext.makeImage() else {
			return nil
		}
		guard let filter = CIFilter(name: "CIBoxBlur") else {
			assertionFailure()
			return nil
		}
		filter.setValue(NSNumber(value: self.box.radius), forKey: "inputRadius")
		let ciimage = CIImage(cgImage: cgimage)
		filter.setValue(ciimage, forKey: "inputImage")
		guard let result = filter.outputImage else {
			assertionFailure()
			return nil
		}
		guard let finalcgimage = Blur.cicontext.createCGImage(result, from: result.extent) else {
			assertionFailure("Unable to create CGImage from context.")
			return nil
		}
		var finalRect = result.extent
		finalRect.center = transformRect.center

		return BlurImage(cgImage: finalcgimage, imageRect: finalRect)
	}

	func drawDiscBlur(forContext blurContext: CGContext, inRect transformRect: CGRect) -> BlurImage? {
		guard let cgimage = blurContext.makeImage() else {
			return nil
		}
		guard let filter = CIFilter(name: "CIDiscBlur") else {
			assertionFailure()
			return nil
		}
		filter.setValue(NSNumber(value: self.disc.radius), forKey: "inputRadius")
		let ciimage = CIImage(cgImage: cgimage)
		filter.setValue(ciimage, forKey: "inputImage")
		guard let result = filter.outputImage else {
			assertionFailure()
			return nil
		}
		guard let finalcgimage = Blur.cicontext.createCGImage(result, from: result.extent) else {
			assertionFailure("Unable to create CGImage from context.")
			return nil
		}
		var finalRect = result.extent
		finalRect.center = transformRect.center

		return BlurImage(cgImage: finalcgimage, imageRect: finalRect)
	}

	func drawMotionBlur(forContext blurContext: CGContext, inRect transformRect: CGRect) -> BlurImage? {
		guard let cgimage = blurContext.makeImage() else {
			return nil
		}
		guard let filter = CIFilter(name: "CIMotionBlur") else {
			assertionFailure()
			return nil
		}
		filter.setValue(NSNumber(value: self.motion.radius), forKey: "inputRadius")
		let radians = (self.motion.angle / 180.0) * .pi
		filter.setValue(NSNumber(value: radians), forKey: "inputAngle")
		let ciimage = CIImage(cgImage: cgimage)
		filter.setValue(ciimage, forKey: "inputImage")
		guard let result = filter.outputImage else {
			assertionFailure()
			return nil
		}
		guard let finalcgimage = Blur.cicontext.createCGImage(result, from: result.extent) else {
			assertionFailure()
			return nil
		}
		var finalRect = result.extent
		finalRect.center = transformRect.center

		return BlurImage(cgImage: finalcgimage, imageRect: finalRect)
	}

	func drawZoomBlur(forContext blurContext: CGContext, inRect transformRect: CGRect) -> BlurImage? {
		guard let cgimage = blurContext.makeImage() else {
			return nil
		}
		guard let filter = CIFilter(name: "CIZoomBlur") else {
			assertionFailure()
			return nil
		}
		filter.setValue(NSNumber(value: self.zoom.distance), forKey: "inputAmount")
		let imageCenter = CGPoint(x: cgimage.width / 2, y: cgimage.height / 2)
		let inputCenter = CGPoint(x: imageCenter.x + CGFloat(self.zoom.center.left), y: imageCenter.y + CGFloat(self.zoom.center.top))
		// filter.setValue(CIVector(cgPoint: imageCenter), forKey: "inputCenter")
		filter.setValue(CIVector(cgPoint: inputCenter), forKey: "inputCenter")
		let ciimage = CIImage(cgImage: cgimage)
		filter.setValue(ciimage, forKey: "inputImage")
		guard let result = filter.outputImage else {
			assertionFailure()
			return nil
		}
		guard let finalcgimage = Blur.cicontext.createCGImage(result, from: result.extent) else {
			assertionFailure()
			return nil
		}
		var finalRect = result.extent
		finalRect.center = transformRect.center

		return BlurImage(cgImage: finalcgimage, imageRect: finalRect)
	}

	func drawMaskBlur(forContext blurContext: CGContext, inRect transformRect: CGRect) -> BlurImage? {
		guard let contextImage = blurContext.makeImage() else {
			return nil
		}
		let backgroundImage = CIImage(cgImage: contextImage)
		let clampedImage = backgroundImage.clampedToExtent()

		guard let gaussianFilter = CIFilter(name: "CIGaussianBlur") else {
			assertionFailure()
			return nil
		}
		gaussianFilter.setValue(clampedImage, forKey: "inputImage")
		gaussianFilter.setValue(self.masked.radius, forKey: "inputRadius")
		guard let gaussianOutput = gaussianFilter.outputImage else {
			assertionFailure()
			return nil
		}
		guard let output = Blur.cicontext.createCGImage(gaussianOutput, from: backgroundImage.extent) else {
			assertionFailure("Unable to create CGImage from context.")
			return nil
		}

		return BlurImage(cgImage: output, imageRect: transformRect)

		//        NOTE: One more way to do. But Masked Variable Blur isn't available for iOS.
		//		  Also not sure if the blur is exactly same as the Gaussian blur.
		//        let mask = CIImage(color: CIColor(cgColor: CGColor(gray: 1, alpha: 1)))
		//        guard let maskFilter = CIFilter(name: "CIMaskedVariableBlur") else {
		//            assert(false)
		//            return
		//        }
		//        maskFilter.setValue(self.gaussian.radius, forKey: kCIInputRadiusKey)
		//        maskFilter.setValue(clampedImage, forKey: kCIInputImageKey)
		//        maskFilter.setValue(mask, forKey: "inputMask")
		//        guard let result = maskFilter.outputImage else {
		//            assert(false)
		//            return
		//        }
		//        guard let output = Blur.cicontext.createCGImage(result, from: backgroundImage.extent) else {
		//            assert(false)
		//            return
		//        }
	}

	var blurValue: Float {
		switch self.type {
		case .unknownType:
			return 0
		case .box:
			return box.radius
		case .disc:
			return disc.radius
		case .gaussian:
			return gaussian.radius
		case .motion:
			return motion.radius
		case .zoom:
			return zoom.distance
		case .masked:
			return masked.radius
		}
	}
}

// Helper function inserted by Swift 4.2 migrator.
private func convertToOptionalCIContextOptionDictionary(_ input: [String: Any]?) -> [CIContextOption: Any]? {
	guard let input = input else {
		return nil
	}
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (CIContextOption(rawValue: key), value) })
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromCIContextOption(_ input: CIContextOption) -> String {
	return input.rawValue
}
#endif
