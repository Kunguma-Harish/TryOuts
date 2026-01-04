//
//  ViewController.swift
//  ShowMacPreferences
//
//  Created by kunguma-14252 on 11/04/23.
//

import Cocoa

class ViewController: NSSplitViewController {
    @IBOutlet weak var leftPane: NSSplitViewItem!
    @IBOutlet weak var rightPane: NSSplitViewItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let leftPane = leftPane.viewController as? LeftViewController {
            leftPane.delegate = self
        }
    }
    
    override var representedObject: Any? {
        didSet {
// Update the view, if already loaded.
        }
    }
}

extension ViewController: NavigationDelegate {
    func changeController(_ vc: NSViewController) {
        self.removeSplitViewItem(self.splitViewItems.last!)
        let splitViewItem = NSSplitViewItem(viewController: vc)
        self.insertSplitViewItem(splitViewItem, at: 1)
    }
}

protocol NavigationDelegate {
    func changeController(_ vc: NSViewController)
}


class DownloadsVc: NSViewController {
    @IBOutlet weak var clearAll: NSButton!
    
    override func viewDidLoad() {
        print("Kungu : DownloadVc")
    }
    
    @IBAction func clearAllAction(_ sender: NSButton) {
        let alert = NSAlert.init()
        alert.messageText = "Remove Presentation_Name"
        alert.informativeText = "Deleting this presentation will remove it from offline storage"
        alert.addButton(withTitle: "Delete")
        alert.addButton(withTitle: "Cancel")
        alert.buttons.first?.hasDestructiveAction = true
        alert.runModal()
    }
    
}
