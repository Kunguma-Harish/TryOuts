//
//  ViewController.swift
//  PullDownTest
//
//  Created by kunguma-14252 on 28/01/25.
//

import AppKit

class ViewController: NSViewController {

    @IBOutlet private weak var pullDownButton: NSPopUpButton!
    
    @IBOutlet weak var cell: NSPopUpButtonCell!
    let items = [["First","Second"],["First","Second"],["First","Second"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureMenuItem()
//        let menu = NSMenu()
//        for item in items
//        {
//            for title in item {
//                let menuItem = NSMenuItem(title: title, action: nil, keyEquivalent: "")
//                menuItem.target = self
//                menu.addItem(menuItem)
//            }
//            menu.addItem(NSMenuItem.separator())
//        }
//        self.pullDownButton.menu = menu
    }
    
    func configureMenuItem() {
        let menu = NSMenu()
        self.items.enumerated().forEach { index, titles in
            let item = NSMenuItem.sectionHeader(title: "Section \(index)")
            menu.addItem(item)
            titles.forEach { title in
                let menuItem = NSMenuItem(title: title, action: nil, keyEquivalent: "")
                menu.addItem(menuItem)
            }
        }
        self.pullDownButton.menu = menu
    }
}
