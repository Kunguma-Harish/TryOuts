//
//  LoaderOverlay.swift
//  dynamicIslantTryOut
//
//  Created by kunguma-14252 on 15/03/23.
//

import Foundation
import UIKit

public class LoaderOverlay {

    private var loaderOverlayView: UIView!

    class var shared: LoaderOverlay {
        struct Static {
            static let instance: LoaderOverlay = LoaderOverlay()
        }
        return Static.instance
    }

    private func setup() {
        loaderOverlayView = UIView(frame: CGRectMake(0, 0, 110, 100))
        loaderOverlayView.backgroundColor = UIColor.yellow
        loaderOverlayView.alpha = 0.8
        loaderOverlayView.layer.cornerRadius = 8

        let indicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .white)
        indicator.tag = 1
        loaderOverlayView.addSubview(indicator)
        indicator.center = CGPointMake(CGRectGetWidth(loaderOverlayView.frame)/2.0, CGRectGetHeight(loaderOverlayView.frame)/2.0)
        indicator.startAnimating()
    }

    // MARK:- Public
    public func show() {
        if loaderOverlayView == nil {
            self.setup()
        } else {
            let indicator = loaderOverlayView.viewWithTag(1) as! UIActivityIndicatorView
            indicator.startAnimating()
        }

        if let window = UIApplication.shared.delegate?.window {
            window!.addSubview(loaderOverlayView)
            loaderOverlayView.center = window!.center
        }
    }

    public func hide() {
        let indicator = loaderOverlayView.viewWithTag(1) as! UIActivityIndicatorView
        indicator.stopAnimating()

        loaderOverlayView.removeFromSuperview()
    }
}
