//
//  ViewController.swift
//  VoiceOverCollectionView
//
//  Created by kunguma-14252 on 21/04/23.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var collectionView: NSCollectionView!
    
    @IBOutlet weak var oneView: NSView!
    
    @IBOutlet weak var someLabel: NSTextField!
    
    @IBOutlet weak var leftView: NSView!
    @IBOutlet weak var button: NSButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(CollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewCell"))
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.configureFlowLayout()
                
        oneView.setAccessibilityEnabled(true)
        oneView.setAccessibilityFocused(true)
        oneView.setAccessibilitySelected(true)
        oneView.setAccessibilityElement(true)

        leftView.setAccessibilityEnabled(true)
        leftView.setAccessibilityFocused(true)
        leftView.setAccessibilitySelected(true)
        leftView.setAccessibilityElement(true)

        someLabel.setAccessibilityEnabled(true)
        someLabel.setAccessibilityFocused(true)
        someLabel.setAccessibilitySelected(true)
        someLabel.setAccessibilityElement(true)
        
        self.button.setAccessibilityChildren([leftView!])
    }
    
//    override func viewDidAppear() {
//        super.viewDidAppear()
//        self.button.setAccessibilityRole(.button)
//        self.someLabel.setAccessibilityRole(.button)
//        self.view.window?.setAccessibilityChildrenInNavigationOrder([self.button, self.collectionView, self.someLabel])
//    }
    
    func configureFlowLayout() {
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 30
        flowLayout.minimumLineSpacing = 30
        flowLayout.sectionInset = NSEdgeInsets(top: 20, left: 30, bottom: 30, right: 30)
        flowLayout.itemSize = NSSize(width: 50, height: 50)
        self.collectionView.collectionViewLayout = flowLayout
    }
    
//    func configureFlowLayout() {
//        let flowLayout = NSCollectionViewFlowLayout()
//        flowLayout.minimumInteritemSpacing = 10
//        flowLayout.minimumLineSpacing = 10
//        flowLayout.sectionInset = NSEdgeInsets(top: 20, left: 30, bottom: 30, right: 30)
//        flowLayout.itemSize = NSSize(width: 75, height: 80)
//        self.collectionView.collectionViewLayout = flowLayout
//    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}


//extension ViewController: NSCollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
//        NSSize(width: 200, height: 200)
//    }
//}
extension ViewController: NSCollectionViewDelegate, NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        23
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        guard let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewCell"), for: indexPath) as? CollectionViewItem else {
            return NSCollectionViewItem()
        }
        item.configure(image: "", label: "Collection Item \(indexPath.item)")
        item.isSelected = false
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let selectedIndex = indexPaths.first,
              let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewCell"), for: selectedIndex) as? CollectionViewItem else {
            return
        }
//        NSAccessibility.post(
//            element: NSApp.mainWindow as Any,
//            notification: .focusedUIElementChanged,
//            userInfo: [
//                .announcement: "This is a custom accessibility notification",
//                .priority: NSAccessibilityPriorityLevel.high.rawValue
//            ]
//        )
        item.isSelected = true
        print("Kungu : Collection Did select \(selectedIndex)")
    }
    
}


class CollectionViewItem: NSCollectionViewItem {
    @IBOutlet weak var image: NSImageView!
    @IBOutlet weak var label: NSTextField!
    
    func configure(image: String, label: String) {
        self.label.wantsLayer = true
        self.label.stringValue = label
        self.label.textColor = .white
        self.view.wantsLayer = true
        self.view.layer?.borderColor = NSColor.systemRed.cgColor
        self.view.setAccessibilityChildren([self.view])
        self.view.setAccessibilityTitle(label + " item")
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.wantsLayer = true
        self.view.layer?.borderColor = NSColor.systemRed.cgColor
    }
    
    override var isSelected: Bool {
        didSet {
            self.view.layer?.backgroundColor = self.isSelected ? NSColor.controlAccentColor.cgColor : NSColor.clear.cgColor
        }
    }
}

class ViewControllerA: NSViewController {
    @IBOutlet weak var outlineView: NSOutlineView!
    
    override func viewDidLoad() {
        self.outlineView.register(NSNib(nibNamed: "OulineViewItem", bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "oulineViewItem"))
        self.outlineView.delegate = self
        self.outlineView.dataSource = self
        
        print("Kungu : Vc A loaded")
    }
}

extension ViewControllerA: NSOutlineViewDelegate, NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        return 10
    }

    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        guard let item = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "oulineViewItem"), owner: self) as? NSTableCellView else {
            return NSView()
        }
        item.textField?.stringValue = "Cell \(String(describing: tableColumn))"
        return item
    }
}

class ViewControllerC: NSViewController {
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var buttonC1: NSButton!
    @IBOutlet weak var buttonC2: NSButton!

    override func viewDidLoad() {
        print("Kungu : Vc C loaded")
    }
}

class AccessView: NSView, NSAccessibilityButton { }


class SplitViewController: NSSplitViewController {
    @IBOutlet private weak var leftPaneItem: NSSplitViewItem!
    @IBOutlet private weak var middlePaneItem: NSSplitViewItem!
    @IBOutlet private weak var rightPaneItem: NSSplitViewItem!
    
    override func viewDidAppear() {
        guard let leftVc = self.leftPaneItem.viewController as? ViewControllerA,
              let middleVc = self.middlePaneItem.viewController as? ViewController,
              let rightVc = self.rightPaneItem.viewController as? ViewControllerC,
              let close = self.view.window?.standardWindowButton(.closeButton),
              let minimise = self.view.window?.standardWindowButton(.miniaturizeButton),
              let fullScreen = self.view.window?.standardWindowButton(.zoomButton)
        else {
            return
        }
        
        let arr = [middleVc.leftView, middleVc.someLabel, rightVc.textField, rightVc.buttonC1, rightVc.buttonC2,close, minimise, fullScreen]
        arr.forEach { view in
            view?.setAccessibilityRole(.button)
        }
        
        let action = NSAccessibilityCustomAction(name: "somthing") {
            print("Kungu : Hitt handler")
            return true
        }
        self.view.window?.setAccessibilityCustomActions([action])
        
        print("Kungu : \(self.view.window?.accessibilityCustomActions())")
        
        let order = [leftVc.outlineView!,middleVc.collectionView!, middleVc.leftView!, middleVc.someLabel!, rightVc.textField!, rightVc.buttonC1!, rightVc.buttonC2!, close, minimise, fullScreen]
        self.view.window?.setAccessibilityChildrenInNavigationOrder(order)
    }
}
