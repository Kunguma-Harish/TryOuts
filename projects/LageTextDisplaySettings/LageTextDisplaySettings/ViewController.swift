//
//  ViewController.swift
//  LageTextDisplaySettings
//
//  Created by kunguma-14252 on 03/05/23.
//

import Cocoa


class WindowController: NSWindowController {
    
    var screenFrame: NSRect = .zero
    var windowFrame: NSRect = .zero
    
    
    override func windowDidLoad() {
        super.windowDidLoad()
//        if let screen = NSScreen.main {
//            self.screenFrame = screen.frame
//            let screenWidth = (self.screenFrame.width * 0.7)
//            let screenHeight = (self.screenFrame.height * 0.7)
////            self.window?.setFrame(NSRect(origin: .zero, size: CGSize(width: screenWidth, height: screenHeight)), display: true)
//
//            self.window?.setContentSize(CGSize(width: screenWidth, height: screenHeight))
//            self.windowFrame = self.window!.frame
//        }
        self.setWindowContentSize()
        self.window?.delegate = self
    }
    
    private func setWindowContentSize() {
        if let window = self.window,
           let screen = window.screen {
            let screenWidth = screen.visibleFrame.width
            let windowContentSize: NSSize
            if screenWidth < 1200 {
                window.fitToScreen()
            } else if screenWidth > 2560 {
                windowContentSize = NSSize(width: 1400, height: 788)
                window.setContentSize(windowContentSize)
            } else {
                windowContentSize = NSSize(width: 1200, height: 675)
                window.setContentSize(windowContentSize)
            }
        }
    }
}

extension NSWindow {
    func fitToScreen() {
        guard let mainScreen = NSScreen.main else {
            return
        }
        self.setFrameOrigin(mainScreen.visibleFrame.origin)
        self.setContentSize(mainScreen.visibleFrame.size)
    }
}

extension WindowController: NSWindowDelegate {
    
    func windowDidMove(_ notification: Notification) {
        self.windowFrame = self.window!.frame
        print("Kungu : Move \(Int.random(in: 0...1000))")
    }
    
    func windowDidChangeScreen(_ notification: Notification) {
        print("Kungu : Change Screen")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.setWindowContentSize()
        }
//        if let screen = NSScreen.main,
//           let window = self.window {
//            let screenWidth = (screen.frame.width * 0.7)
//            let screenHeight = (screen.frame.height * 0.7)
//
//            let zoom1 = screen.frame.width / self.screenFrame.width
//            let zoom2 = screen.frame.width / self.screenFrame.width
//            let updateFrame = NSRect(origin: windowFrame.origin, size: CGSize(width: screenWidth, height: screenHeight))
//            self.window?.setFrame(updateFrame, display: true)
//
//            self.screenFrame = screen.frame
//            self.windowFrame = updateFrame
//        }
    }
    
    func windowDidChangeBackingProperties(_ notification: Notification) {
        print("Kungu : property")
    }
}

class SplitViewController: NSSplitViewController {
    
    @IBOutlet weak var splitItemA: NSSplitViewItem!
    @IBOutlet weak var splitItemB: NSSplitViewItem!
    @IBOutlet weak var splitItemC: NSSplitViewItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splitItemA.canCollapse = false
        splitItemB.canCollapse = false
        splitItemC.canCollapse = false
        splitItemA.minimumThickness = self.view.frame.width * 0.15
        splitItemB.minimumThickness = self.view.frame.width * 0.65
        splitItemC.minimumThickness = self.view.frame.width * 0.20
    }
}

class ViewControllerA: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.systemCyan.cgColor
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}

class ViewControllerB: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.systemPink.cgColor
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

class ViewControllerC: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.systemGray.cgColor
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}



