//
//  VcWithTabView.swift
//  TabBarController
//
//  Created by kunguma-14252 on 11/02/25.
//

import AppKit

class VcWithTabView: NSViewController {
    @IBOutlet weak var tabView: NSTabView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Kungu : viewDidLoad.")
    }

    @IBAction func actionButtonTapped(_ sender: Any) {
        self.tabView.selectTabViewItem(at: (0...10).randomElement() ?? 0)
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        for i in 0...10 {
            let vc = NSViewController()
            vc.view.wantsLayer = true
            vc.view.layer?.backgroundColor = NSColor.random.cgColor
            let tabItem = NSTabViewItem(viewController: vc)
            tabItem.label = "Tab \(i)"
            self.tabView.addTabViewItem(tabItem)
        }
    }

    deinit {
        print("Kungu : \(self.classForCoder).")
    }
}

extension CGFloat {
    static var random: CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension NSColor {
    static var random: NSColor {
        return NSColor(red: .random, green: .random, blue: .random, alpha: 1.0)
    }
}
