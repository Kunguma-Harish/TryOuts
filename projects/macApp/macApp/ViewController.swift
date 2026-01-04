//
//  ViewController.swift
//  macApp
//
//  Created by kunguma-14252 on 06/04/23.
//

import Cocoa
import SwiftUI

class ViewController: NSViewController {
    
    @IBOutlet weak var customView: NSView!
    @IBOutlet weak var button: NSButton!
    
    var count: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        count += 1
        if count%2 != 0 {
            let swiftUIView = NSHostingView(rootView: SwiftUIView())
            self.customView.addSubview(swiftUIView)
            swiftUIView.translatesAutoresizingMaskIntoConstraints = false
            swiftUIView.leadingAnchor.constraint(equalTo: customView.leadingAnchor).isActive = true
            swiftUIView.trailingAnchor.constraint(equalTo: customView.trailingAnchor).isActive = true
            swiftUIView.topAnchor.constraint(equalTo: customView.topAnchor).isActive = true
            swiftUIView.bottomAnchor.constraint(equalTo: customView.bottomAnchor).isActive = true
        }else {
            self.customView.subviews.forEach { subView in
                self.customView.willRemoveSubview(subView)
            }
        }
    }
    
}


class HostingController: NSHostingController<SwiftUIView> {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: SwiftUIView())
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
