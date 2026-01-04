//
//  ViewController.swift
//  KeyBinding
//
//  Created by kunguma-14252 on 18/07/24.
//

import Cocoa

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

class LeftViewController: NSSplitViewController {

    @IBOutlet weak var outlineView: NSOutlineView!
    
    var arrOfData: [OutlineViewData] = [
        
        .group(name: "Group1", items: [
            .item(title: "G1_Item1"),
            .item(title: "G1_Item2"),
            .group(name: "InsideG1", items: [
                .item(title: "Inside_G1_Item1"),
                .item(title: "Inside_G1_Item2"),
            ],
                   isExpanded: true,
                   shouldCollapse: true
            ),
            .item(title: "G1_Item3"),
            .item(title: "G1_Item4")
        ],
               isExpanded: true,
               shouldCollapse: false
              ),
        .group(name: "GroupA", items: [
            .item(title: "Inside_GA_Item1"),
            .item(title: "Inside_GA_Item2"),
        ],
               isExpanded: true,
               shouldCollapse: true
        ),
        .item(title: "Item1"),
        .item(title: "Item2"),
        .group(name: "Group2", items: [
            
            .item(title: "G2_Item1"),
            .item(title: "G2_Item2"),
            .group(name: "InsideG2", items: [
                .item(title: "Inside_G2_Item1"),
                .item(title: "Inside_G2_Item2"),
            ],
                   isExpanded: true,
                   shouldCollapse: true
            )
        ],
               isExpanded: true,
               shouldCollapse: true
              )
        
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.outlineView.delegate = self
        self.outlineView.dataSource = self
        self.outlineView.register(NSNib(nibNamed: "OutlineViewCell", bundle: nil), forIdentifier:  NSUserInterfaceItemIdentifier("OutlineViewCell"))
    }
}

extension LeftViewController: NSOutlineViewDelegate, NSOutlineViewDataSource {
    func outlineView(_: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        guard let filterItem = item as? OutlineViewData else {
            return self.arrOfData.count
        }

        switch filterItem {
        case let .group(_, items, _, _):
            return items.count
        case .item:
            return 0
        }
    }

    func outlineView(_: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        guard let filterItem = item as? OutlineViewData else {
            return self.arrOfData[index]
        }

        switch filterItem {
        case let .group(_, items, _, _):
            return items[index]
        case .item:
            return filterItem
        }
    }

    func outlineView(_: NSOutlineView, isItemExpandable item: Any) -> Bool {
        guard let filterItem = item as? OutlineViewData,
              case let .group(_, items, _, _) = filterItem
        else {
            return false
        }

        return !items.isEmpty
    }

    func outlineView(_: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        guard let filterItem = item as? OutlineViewData else {
            return false
        }
        switch filterItem {
        case .group:
            return false
        case .item:
            return true
        }
    }

    func outlineView(_: NSOutlineView, heightOfRowByItem _: Any) -> CGFloat {
        30
    }

    func outlineView(_: NSOutlineView, shouldCollapseItem item: Any) -> Bool {
        guard let filterItem = item as? OutlineViewData else {
            return false
        }
        switch filterItem {
        case let .group(_, _, _, shouldCollapse):
            return shouldCollapse
        default:
            return false
        }
    }

    func outlineView(_: NSOutlineView, shouldShowOutlineCellForItem item: Any) -> Bool {
        guard let filterItem = item as? OutlineViewData else {
            return false
        }
        switch filterItem {
        case let .group(_, _, _, shouldCollapse):
            return shouldCollapse
        default:
            return false
        }
    }

    func outlineViewItemDidExpand(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let outlineViewData = userInfo["NSObject"] as? OutlineViewData
        else {
            return
        }
        print("Kungu: Expand -- \(outlineViewData)")
//        if case let .group(_, _, isExpanded, shouldCollapse) = outlineViewData, shouldCollapse, !isExpanded {
//            self.expandCollapse(element: outlineViewData, isExpanded: true)
//        }
    }

    func outlineViewItemDidCollapse(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let outlineViewData = userInfo["NSObject"] as? OutlineViewData
        else {
            return
        }
        print("Kungu: Collapse -- \(outlineViewData)")
//        if case let .group(_, _, isExpanded, shouldCollapse) = outlineViewData, shouldCollapse, isExpanded {
//            self.expandCollapse(element: outlineViewData, isExpanded: false)
//        }
    }

//    func outlineViewSelectionDidChange(_ notification: Notification) {
//        guard let object = notification.object as? NSOutlineView,
//              let filterItem = object.item(atRow: object.selectedRow) as? OutlineViewData,
//              case let .item(data) = filterItem,
//              let data = data as? CreateFilterOutlineViewChild
//        else {
//            return
//        }
//        self.viewModel.createDeleteItem(filter: data.filter)
//        self.viewModel.switchFilter(data.filter)
//    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        guard let filterItem = item as? OutlineViewData,
              let view = outlineView.makeView(
                withIdentifier: NSUserInterfaceItemIdentifier("OutlineViewCell"),
                owner: self
              ) as? OutlineViewCell else {
            return nil
        }
        switch filterItem {
        case let .group(data, _, _, _):
            
            view.configure(title: data)
            
        case let .item(data):
            view.configure(
                title: data
            )
        }
        return view
    }
}
enum OutlineViewData: Equatable {
    case group(name: String, items: [OutlineViewData], isExpanded: Bool, shouldCollapse: Bool)
    case item(title: String)
}
class RightViewController: NSViewController {

    @IBOutlet weak var collectionView: NSCollectionView!
    
    let minimumItemSpacing = 24.0
    let edgeInset =  NSEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(CollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewCell"))
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
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
}

extension RightViewController {
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

extension RightViewController: NSCollectionViewDelegateFlowLayout {
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

extension RightViewController: NSCollectionViewDelegate, NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        100
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
        let item = collectionView.item(at: selectedIndex.item) as? CollectionViewItem else {
            return
        }
        item.isSelected = true
        print("Kungu : Collection Did select \(selectedIndex)")
    }
}


class CollectionViewItem: NSCollectionViewItem {
    @IBOutlet weak var image: NSImageView!
    @IBOutlet weak var label: NSTextField!
    
    override var isSelected: Bool {
        didSet {
            self.image.layer?.borderWidth = self.isSelected ? 2 : 1
            self.image.layer?.borderColor = self.isSelected ? NSColor.controlAccentColor.cgColor : NSColor.separatorColor.cgColor
            self.label.layer?.backgroundColor = self.isSelected ? NSColor.controlAccentColor.cgColor : NSColor.clear.cgColor
            self.label.textColor = self.isSelected ? .white : NSColor.labelColor
        }
    }
    
    func configure(image: String, label: String) {
        self.label.stringValue = label
    }
}

class OutlineViewCell: NSTableCellView {
    
    @IBOutlet weak var titleLabel: NSTextField!
    
    func configure(title: String) {
        self.titleLabel.stringValue = title
    }
}
