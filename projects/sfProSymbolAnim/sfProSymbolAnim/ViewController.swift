//
//  ViewController.swift
//  sfProSymbolAnim
//
//  Created by kunguma-14252 on 19/07/23.
//

import Cocoa

@available(macOS 14.0, *)
class ViewController: NSViewController, ContentTransitionSymbolEffect {

    @IBOutlet weak var imageView: NSImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let symbolImage = NSImage(named: NSImage.Name("pencil.and.outline")) {
//            let options: NSImageView.SymbolImageOptions = [.scaleProportionallyUpOrDown, .alignCenter]
            self.imageView.image = symbolImage
            self.imageView.setSymbolImage(symbolImage, contentTransition: .automatic, options: .default)
            
                }
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}
//
//class SomeImage: NSImage, ContentTransitionSymbolEffect {
//    override func setSymbolImage(_ image: NSImage, contentTransition: some ContentTransitionSymbolEffect & SymbolEffect, options: SymbolEffectOptions = .default) {
//        print("Kungu : Something hits")
//    }
//}
