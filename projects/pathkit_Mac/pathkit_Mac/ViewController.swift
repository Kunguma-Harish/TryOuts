//
//  ViewController.swift
//  pathkit_Mac
//
//  Created by kunguma-14252 on 08/06/23.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var button: NSButton!
    @IBOutlet weak var expandableView: NSView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.expandableView.wantsLayer = true
        self.expandableView.layer?.backgroundColor = NSColor.systemRed.cgColor
        self.scrollView.documentView?.setFrameSize(NSSize(width: 30, height: 30))
//        self.scrollView.setBoundsSize(self.expandableView.frame.size)
        
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func buttonAction(_ sender: Any) {
        self.height.constant += 30
        self.scrollView.documentView?.setFrameSize(NSSize(width: 30, height: self.height.constant))
        self.view.layoutSubtreeIfNeeded()
        
    }
    
}

