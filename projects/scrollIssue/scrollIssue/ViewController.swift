//
//  ViewController.swift
//  scrollIssue
//
//  Created by kunguma-14252 on 17/08/23.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var collectionView: CustomCollectionView!
    @IBOutlet weak var gridLayout: StickyGridCollectionViewFlowLayout! {
        didSet {
            gridLayout.stickyRowsCount = 2
            gridLayout.stickyColumnsCount = 2
        }
    }
    
    var item: Int = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let headerViewItemNib = NSNib(nibNamed: "ItemView", bundle: .main)
        self.collectionView.register(
            headerViewItemNib,
            forItemWithIdentifier: NSUserInterfaceItemIdentifier("ItemView")
        )
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

extension ViewController: NSCollectionViewDelegateFlowLayout {
    func collectionView(_: NSCollectionView, layout _: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        if indexPath.section == 0, indexPath.item == 0 {
            return NSSize(width: 17, height: 15)
        } else if indexPath.section == 0 {
            return NSSize(width: 103, height: 15)
        } else if indexPath.item == 0 {
            return NSSize(width: 17, height: 29)
        }
        return NSSize(width: 103, height: 29)
    }

    func collectionView(_: NSCollectionView, layout _: NSCollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        .zero
    }

    func collectionView(_: NSCollectionView, layout _: NSCollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        .zero
    }
}

// MARK: - NSCollectionViewDataSource Conformance

extension ViewController: NSCollectionViewDataSource {
    func numberOfSections(in _: NSCollectionView) -> Int {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.item += 3
            self.collectionView.reloadData()
        }
        return 5
    }

    func collectionView(_: NSCollectionView, numberOfItemsInSection _: Int) -> Int {
        self.item
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let emptyCells: [IndexPath] = [
            IndexPath(item: 0, section: 0),
            IndexPath(item: 0, section: 1),
            IndexPath(item: 1, section: 0),
            IndexPath(item: 1, section: 1)
        ]
        if emptyCells.contains(indexPath) || indexPath.section == 0 || indexPath.item == 0 {
            let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ItemView"), for: indexPath)
            item.textField?.stringValue = "Sec \(indexPath.item)"
            return item
        }
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ItemView"), for: indexPath)
        item.textField?.stringValue = "Row \(indexPath.item)"
        return item
    }
}

private extension IndexPath {
    init(row: Int, column: Int) {
        self = IndexPath(item: column, section: row)
    }
}


class StickyGridCollectionViewFlowLayout: NSCollectionViewFlowLayout {
    private enum ZOrder {
        static let commonItem = 0
        static let stickyItem = 1
        static let staticStickyItem = 2
    }

    private var contentSize = CGSize.zero
    private var allAttributes = [[NSCollectionViewLayoutAttributes]]()

    var stickyRowsCount = 0 {
        didSet {
            invalidateLayout()
        }
    }

    var stickyColumnsCount = 0 {
        didSet {
            invalidateLayout()
        }
    }

    override var collectionViewContentSize: CGSize {
        contentSize
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [NSCollectionViewLayoutAttributes] {
        var layoutAttributes = [NSCollectionViewLayoutAttributes]()

        for rowAttributes in self.allAttributes {
            for colAttributes in rowAttributes where rect.intersects(colAttributes.frame) {
                layoutAttributes.append(colAttributes)
            }
        }

        return layoutAttributes
    }

    override func shouldInvalidateLayout(forBoundsChange _: CGRect) -> Bool {
        true
    }

    override func prepare() {
        self.setupAttributes()
        let lastFrame = self.allAttributes.last?.last?.frame ?? .zero
        self.contentSize = CGSize(width: lastFrame.maxX, height: lastFrame.maxY)
    }

    func isItemSticky(at indexPath: IndexPath) -> Bool {
        indexPath.item < self.stickyColumnsCount || indexPath.section < self.stickyRowsCount
    }

    func resetContentOffset() {
        #if os(iOS)
            self.collectionView?.setContentOffset(.zero, animated: false)
        #endif
    }
}

private extension StickyGridCollectionViewFlowLayout {
    var rowsCount: Int {
        collectionView?.numberOfSections ?? 0
    }

    func columnsCount(in row: Int) -> Int {
        collectionView?.numberOfItems(inSection: row) ?? 0
    }

    func setupAttributes() {
        self.allAttributes = [] // Reset attributes

        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0

        for row in 0 ..< self.rowsCount {
            var rowAttributes = [NSCollectionViewLayoutAttributes]()
            xOffset = 0

            for col in 0 ..< self.columnsCount(in: row) {
                let itemSize = self.size(forRow: row, column: col)
                let indexPath = IndexPath(row: row, column: col)
                let attributes = NSCollectionViewLayoutAttributes(forItemWith: indexPath)
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height).integral

                if row < self.stickyRowsCount {
                    var frame = attributes.frame
                    frame.origin.y +=  self.collectionView?.visibleRect.origin.y ?? 0
                    attributes.frame = frame
                }

                if col < self.stickyColumnsCount {
                    var frame = attributes.frame
                    frame.origin.x +=  self.collectionView?.visibleRect.origin.x ?? 0
                    attributes.frame = frame
                }

                // Position the sticky cell on top of all other cells
                attributes.zIndex = self.zIndex(forRow: row, column: col)
                rowAttributes.append(attributes)
                xOffset += itemSize.width
            }

            yOffset += rowAttributes.last?.frame.height ?? 0.0
            self.allAttributes.append(rowAttributes)
        }
    }

    func size(forRow row: Int, column: Int) -> CGSize {
        guard
            let delegate = collectionView?.delegate as? NSCollectionViewDelegateFlowLayout,
            let collectionView = self.collectionView,
            let size = delegate.collectionView?(
                collectionView,
                layout: self,
                sizeForItemAt: IndexPath(row: row, column: column)
            )
        else {
            assertionFailure("Implement collectionView(_,layout:,sizeForItemAt: in UICollectionViewDelegateFlowLayout")
            return .zero
        }
        return size
    }

    func zIndex(forRow row: Int, column col: Int) -> Int {
        if row < self.stickyRowsCount && col < self.stickyColumnsCount {
            return ZOrder.staticStickyItem
        } else if row < self.stickyRowsCount || col < self.stickyColumnsCount {
            return ZOrder.stickyItem
        } else {
            return ZOrder.commonItem
        }
    }
}
