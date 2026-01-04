//
//  TabBar1.swift
//  TabBarController
//
//  Created by kunguma-14252 on 11/02/25.
//

import Cocoa

class TabBar1: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        if let layer = self.view.layer {
            layer.backgroundColor = NSColor.systemCyan.cgColor
        }
    }
    
    deinit {
        print("Kungu : \(self.classForCoder).")
    }
}
