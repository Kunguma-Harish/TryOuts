//
//  ViewController.swift
//  HeleprSpm
//
//  Created by kunguma-14252 on 17/06/24.
//

import Cocoa
import MacTarget

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction private func actionButtonClick(_ sender: NSButton) {
        EditorVC.execute()
        guard let vc = NSStoryboard().initialVC else {
            return
        }
        presentAsSheet(vc)
    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

