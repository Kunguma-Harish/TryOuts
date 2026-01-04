//
//  ViewController.swift
//  nextResponderTest
//
//  Created by kunguma-14252 on 19/04/23.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var customView: CustomControllView!
    //    @IBOutlet weak var box: CustomBox!
    @IBOutlet weak var box: CustomBox!
    @IBOutlet weak var button: NSButton!
    @IBOutlet weak var textView4: NSTextField!
    @IBOutlet weak var textView3: NSTextField!
    @IBOutlet weak var textView2: NSTextField!
    @IBOutlet weak var textView1: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Kungu : isFullKeyboardAccessEnabled -- \(NSApplication.shared.isFullKeyboardAccessEnabled)")
    }

    override func viewDidAppear() {
        
        self.view.nextKeyView = textView3
        
        self.box.nextKeyView = textView1
        textView1.nextKeyView = textView3
        textView3.nextKeyView = textView2
        textView2.nextKeyView = textView4
        textView4.nextKeyView = self.box
        
    }
}

class CustomBox: NSBox {
    override var canBecomeKeyView: Bool {
        return true
    }
    
    override var acceptsFirstResponder: Bool {
        print("Kungu : Accepts first responder")
        return true
    }
}

class CustomView: NSButton {
    override func becomeFirstResponder() -> Bool {
        print("Kungu : NSControll")
        return true
    }
    
    override var canBecomeKeyView: Bool {
        print("Kungu : NSControl become key view")
        return true
    }
    
    override var acceptsFirstResponder: Bool {
        print("Kungu : Accepts first responder")
        return true
    }
}


class CustomControllView: NSControl {
//, NSUserInterfaceValidations, NSAccessibilityButton, NSUserInterfaceCompression
//    func validateUserInterfaceItem(_ item: NSValidatedUserInterfaceItem) -> Bool {
//        return true
//    }
//    
//    func compress(withPrioritizedCompressionOptions prioritizedOptions: [NSUserInterfaceCompressionOptions]) {
//        print("Kungu: Compress(withPrioritizedCompressionOpt")
//    }
//    
//    func minimumSize(withPrioritizedCompressionOptions prioritizedOptions: [NSUserInterfaceCompressionOptions]) -> NSSize {
//        return NSSize(width: 100, height: 100)
//    }
//    
//    var activeCompressionOptions: NSUserInterfaceCompressionOptions
    
    override var acceptsFirstResponder: Bool {
        return true
    }

    override var canBecomeKeyView: Bool {
        return true
    }

    override func becomeFirstResponder() -> Bool {
        return true
    }

    override func drawFocusRingMask() {
        // Draw focus ring
        NSBezierPath(rect: self.bounds).fill()
    }

    override var focusRingMaskBounds: NSRect {
        self.bounds
    }

    override init(frame frameRect: NSRect) {
//        self.activeCompressionOptions = .standardOptions
        super.init(frame: frameRect)
        self.commonInit()
    }

    required init?(coder: NSCoder) {
//        self.activeCompressionOptions = .standardOptions
        super.init(coder: coder)
        self.commonInit()
    }

    private func commonInit() {
        // Set up your view here
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.red.cgColor
        if let window = self.window {
            window.makeFirstResponder(self)
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here
        let path = NSBezierPath(rect: bounds)
        NSColor.blue.setFill()
        path.fill()
    }
}
