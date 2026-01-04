//
//  ViewController.swift
//  collectionView_keynoteBehaviour
//
//  Created by kunguma-14252 on 01/06/23.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var collectionView: NSCollectionView!
    
    let minimumItemSpacing = 24.0
    let edgeInset =  NSEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
    
    @IBAction func buttonAction(_ sender: Any) {
//        self.collectionView.collectionViewLayout?.invalidateLayout()
        self.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.collectionView.register(CollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewCell"))
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.addObserver()
    }
//
//    override func viewDidLayout() {
//        super.viewDidLayout()
//        self.collectionView.collectionViewLayout?.invalidateLayout()
//    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(invalidateCollectionView), name: NSNotification.Name(rawValue: "WindowResized"), object: nil)
    }
    
    @objc func invalidateCollectionView() {
        self.collectionView.collectionViewLayout?.invalidateLayout()
    }

    func getItemsPerRow() -> CGFloat {
        var numberOfItem: Int = 5
        guard let windowWidth = self.view.window?.frame.width else {
            return CGFloat(integerLiteral: numberOfItem)
        }
        
        if windowWidth >= 1200 {
            numberOfItem = 5
        }else if windowWidth < 1200 && windowWidth >= 800  {
            numberOfItem = 4
        }else if windowWidth < 800 && windowWidth > 700 {
            numberOfItem = 3
        }else {
            numberOfItem = 2
        }
        
        return CGFloat(integerLiteral: numberOfItem)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

extension ViewController {
    func getSize(isNumberOfItemReduced: Bool = false, isNumberOfItemIncreased: Bool = false) -> NSSize {
        let collectionViewWidth = self.collectionView.frame.width
        let interItemSpace = self.minimumItemSpacing
        let insets = self.edgeInset.left * 2
        let minWidth = 120.0
        let maxWidth = 306.0
        
        var numberOfItemPerRow: Int = max(Int(collectionViewWidth / maxWidth), 1)
        if isNumberOfItemReduced {
            numberOfItemPerRow = max((numberOfItemPerRow - 1), 1)
        }else if isNumberOfItemIncreased {
            numberOfItemPerRow += 1
        }
        
        let availableWidth = collectionViewWidth - insets - (Double((numberOfItemPerRow - 1)) * interItemSpace)
        let widthPerItem = floor(availableWidth / Double(numberOfItemPerRow))
        let height = widthPerItem * (9/16)

        if widthPerItem < minWidth {
            return self.getSize(isNumberOfItemReduced: true)
        }else if widthPerItem > maxWidth {
            return self.getSize(isNumberOfItemIncreased: true)
        }
        return NSSize(width: widthPerItem, height: height)
    }
}

extension ViewController: NSCollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: NSCollectionView,
        layout _: NSCollectionViewLayout,
        sizeForItemAt _: IndexPath
    ) -> NSSize {
        self.getSize()
    }

    func collectionView(
        _: NSCollectionView,
        layout _: NSCollectionViewLayout,
        minimumLineSpacingForSectionAt _: Int
    ) -> CGFloat {
        self.minimumItemSpacing
    }

    func collectionView(
        _: NSCollectionView,
        layout _: NSCollectionViewLayout,
        minimumInteritemSpacingForSectionAt _: Int
    ) -> CGFloat {
        self.minimumItemSpacing
    }

    func collectionView(
        _: NSCollectionView,
        layout _: NSCollectionViewLayout,
        insetForSectionAt _: Int
    ) -> NSEdgeInsets {
        self.edgeInset
    }
}

extension ViewController: NSCollectionViewDelegate, NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        guard let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewCell"), for: indexPath) as? CollectionViewItem else {
            return NSCollectionViewItem()
        }
        item.configure(image: "", label: "\(indexPath.item + 1)")
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let selectedIndex = indexPaths.first,
              let _ = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewCell"), for: selectedIndex) as? CollectionViewItem else {
            return
        }
        print("Kungu : Collection Did select \(selectedIndex)")
    }
}


class CollectionViewItem: NSCollectionViewItem {
    @IBOutlet weak var image: NSImageView!
    @IBOutlet weak var label: NSTextField!
    
    func configure(image: String, label: String) {
        self.label.stringValue = label
        self.label.backgroundColor = .white
        self.label.textColor = .black
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.systemIndigo.cgColor
    }
}


class SplitViewController: NSSplitViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Kungu : SplitViewLoaded")
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.splitViewItems[0].minimumThickness = self.view.window!.frame.width * 0.3
        self.splitViewItems[0].maximumThickness = self.view.window!.frame.width * 0.3
    }
}

class WindowController: NSWindowController {
    private var windowController: NSWindowController?
    override func windowDidLoad() {
        super.windowDidLoad()
        self.windowController = self
        self.window?.delegate = self
    }
}

extension WindowController: NSWindowDelegate {
    func windowDidResize(_ notification: Notification) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WindowResized"), object: nil)
    }
}
