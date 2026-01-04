//
//  CustomView.swift
//  hitTest
//
//  Created by kunguma-14252 on 13/03/23.
//

import Foundation
import UIKit

class CustomView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        print("Kungu : \(String(describing: event))")
        return self
//        for subview in self.subviews.reversed() {
//            let subPoint = subview.convert(point, from:self)
//            if subview.point(inside: subPoint, with: event) == true {
//                if let result = subview.hitTest(subPoint, with: event) {
//                    return result
//                } else {
//                    return subview
//                }
//            }
//        }
//        if self.point(inside: point, with: event) == true {
//            return self
//        } else {
//            return nil
//        }
    }
}
