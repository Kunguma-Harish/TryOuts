//
//  TransitionData.swift
//  Painter
//
//  Created by Pravin Palaniappan on 01/07/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

#if !os(watchOS)
import Proto
import QuartzCore

public class TransitionData {
	// MARK: Delegates

	weak var delegate: CAAnimationDelegate?

	// MARK: Properties

	var fromView: CALayer
	var toView: CALayer
	var isReverse = false
	var duration: Float
	var displayAnim: DisplayAnimation
	var delay: Float
	var id: String
	var easing: CAMediaTimingFunction?

	public init(
		from: CALayer,
		to: CALayer,
		transitionType: DisplayAnimation,
		duration: Float,
		delay: Float,
		delegate: CAAnimationDelegate? = nil,
		isReverse: Bool = false,
		id: String = "",
		easing: CAMediaTimingFunction? = nil) {
		self.delegate = delegate
		self.fromView = from
		self.toView = to
		self.isReverse = isReverse
		self.duration = duration
		self.delay = delay
		self.displayAnim = transitionType
		self.id = id
		self.easing = easing
	}
}

#endif
