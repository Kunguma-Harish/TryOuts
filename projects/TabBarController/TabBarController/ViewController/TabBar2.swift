//
//  TabBar2.swift
//  TabBarController
//
//  Created by kunguma-14252 on 11/02/25.
//

import Cocoa

class TabBar2: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        if let layer = self.view.layer {
            layer.backgroundColor = NSColor.darkGray.cgColor
        }
    }

    deinit {
        print("Kungu : \(self.classForCoder).")
    }
}
