//
//  Window.swift
//  nextResponderTest
//
//  Created by kunguma-14252 on 20/04/23.
//

import Cocoa

class Window: NSWindow {
//    override var initialFirstResponder: NSView? {
//        guard let vc = self.contentViewController as? ViewController else {
//            return
//        }
//        return vc.textView3
//    }
    
    override func recalculateKeyViewLoop() {
        guard let vc = self.contentViewController as? ViewController else {
            return
        }
        self.makeFirstResponder(vc.customView)
//        self.makeFirstResponder(vc.box)
//        vc.nextResponder = vc.box
        print("Kungu : recalculateKeyViewLoop")
    }
}

class WindowController: NSWindowController {
    override func windowDidLoad() {
        guard let vc = self.contentViewController as? ViewController else {
            return
        }
        self.window?.initialFirstResponder = vc.box
    }
}
