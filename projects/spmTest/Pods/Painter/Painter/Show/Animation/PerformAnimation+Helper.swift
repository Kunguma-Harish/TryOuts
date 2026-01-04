//
//  PerformAnimation+Helper.swift
//  Painter
//
//  Created by Sarath Kumar G on 26/02/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

#if !os(watchOS)
import QuartzCore

extension PerformAnimation {
	func createPathAnimation() {
		let pathAnimation = CABasicAnimation()
		pathAnimation.keyPath = "path"
		pathAnimation.fromValue = coreAnimationData.custom.atStart.path.cgpath
		pathAnimation.toValue = coreAnimationData.custom.byEnd.path.cgpath
		groupAnimation.append(pathAnimation)
	}

	func createPathToFollowAnimation() {
		let pathAnimation = CAKeyframeAnimation()
		pathAnimation.keyPath = "position"
		pathAnimation.path = coreAnimationData.custom.pathToFollow.cgpath
		pathAnimation.calculationMode = CAAnimationCalculationMode.paced
		if self.stayObjectAlong {
			pathAnimation.rotationMode = .rotateAuto
		}
		groupAnimation.append(pathAnimation)
	}
}
#endif
