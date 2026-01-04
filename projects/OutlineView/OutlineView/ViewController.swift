//
//  ViewController.swift
//  OutlineView
//
//  Created by kunguma-14252 on 12/05/23.
//

import Cocoa

class OutlineViewCell: NSTableCellView {
    
    @IBOutlet weak var titleLabel: NSTextField!
    
    func configure(title: String) {
        self.titleLabel.stringValue = title
    }
}

class ViewController: NSViewController {
    
    @IBAction func reloadData(_ sender: Any) {
        self.expandCollapse(element:  arrOfData[4], isExpanded: Bool.random())
    }
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

    @IBOutlet weak var outlineView: NSOutlineView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.outlineView.delegate = self
        self.outlineView.dataSource = self
        self.outlineView.register(NSNib(nibNamed: "OutlineViewCell", bundle: nil), forIdentifier:  NSUserInterfaceItemIdentifier("OutlineViewCell"))
        
        
        var index: Int = 0
        self.expandCollapseItems(with: self.arrOfData, index: &index)
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

extension ViewController {
    func expandCollapseItems(with outlineViewData: [OutlineViewData], index: inout Int) {
        for element in outlineViewData {
            if case let .group(_, items, isExpanded, _) = element {
                if isExpanded {
                    self.outlineView.expandItem(self.outlineView.item(atRow: index))
                    index += 1
                    self.expandCollapseItems(with: items, index: &index)
                } else {
                    index += 1
                }
            } else {
                index += 1
            }
        }
    }
    
    
    func expandCollapse(element: OutlineViewData, isExpanded: Bool) {
        let updatedData = self.updatedData(of: element, datas: self.arrOfData, isExpanded: isExpanded)
        self.arrOfData = updatedData
        self.outlineView.reloadData()
        var index: Int = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.expandCollapseItems(with: self.arrOfData, index: &index)
        })
    }

    private func updatedData(of element: OutlineViewData, datas: [OutlineViewData], isExpanded: Bool) -> [OutlineViewData] {
        var result: [OutlineViewData] = []
        datas.forEach { outlineViewData in
            var updatedOutlineViewData: OutlineViewData
            if case let .group(data, items, actualIsExpanded, shouldCollapse) = outlineViewData {
                let updatedItems = updatedData(of: element, datas: items, isExpanded: isExpanded)
                var updatedExpandedValue = actualIsExpanded
                if outlineViewData == element {
                    updatedExpandedValue = isExpanded
                }
                updatedOutlineViewData = .group(name: data, items: updatedItems, isExpanded: updatedExpandedValue, shouldCollapse: shouldCollapse)
            } else {
                updatedOutlineViewData = outlineViewData
            }
            result.append(updatedOutlineViewData)
        }
        return result
    }
}

enum OutlineViewData: Equatable {
    case group(name: String, items: [OutlineViewData], isExpanded: Bool, shouldCollapse: Bool)
    case item(title: String)
}

extension ViewController: NSOutlineViewDelegate, NSOutlineViewDataSource {
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
        if case let .group(_, _, isExpanded, shouldCollapse) = outlineViewData, shouldCollapse, !isExpanded {
            self.expandCollapse(element: outlineViewData, isExpanded: true)
        }
    }

    func outlineViewItemDidCollapse(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let outlineViewData = userInfo["NSObject"] as? OutlineViewData
        else {
            return
        }
        print("Kungu: Collapse -- \(outlineViewData)")
        if case let .group(_, _, isExpanded, shouldCollapse) = outlineViewData, shouldCollapse, isExpanded {
            self.expandCollapse(element: outlineViewData, isExpanded: false)
        }
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

