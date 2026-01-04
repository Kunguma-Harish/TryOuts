//
//  LeftViewController.swift
//  ShowMacPreferences
//
//  Created by kunguma-14252 on 11/04/23.
//

import AppKit
import Foundation

class LeftViewController: NSViewController{
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var scrollTable: NSScrollView!
    
    var delegate: NavigationDelegate? = nil

    let listOfItems = ["General","Appearance","Accounts","Privacy & Feedback","Downloads"]
    let icons = ["gearshape", "display", "person.and.background.dotted", "arrow.down", "shield"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
}


extension LeftViewController: NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        listOfItems.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: (tableColumn?.identifier)!.rawValue), owner: self) as? NSTableCellView else {
            return nil
        }
        tableView.intercellSpacing = NSSize(width: 0, height: 10)
        cell.textField?.stringValue = listOfItems[row]
        return cell
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        return SelectionView()
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        let tableView = notification.object as! NSTableView
        let selectedRows = tableView.selectedRowIndexes
        if let index = selectedRows.first {
            
            switch index {
            case 0:
                guard let vc = storyboard?.instantiateController(withIdentifier: "General") as? NSViewController else {
                    return
                }
                delegate?.changeController(vc)
            case 1:
                guard let vc = storyboard?.instantiateController(withIdentifier: "Appearance") as? NSViewController else {
                    return
                }
                delegate?.changeController(vc)
            case 2:
                guard let vc = storyboard?.instantiateController(withIdentifier: "Accounts") as? NSViewController else {
                    return
                }
                delegate?.changeController(vc)
            case 3:
                guard let vc = storyboard?.instantiateController(withIdentifier: "Privacy") as? NSViewController else {
                    return
                }
                delegate?.changeController(vc)
            case 4:
                guard let vc = storyboard?.instantiateController(withIdentifier: "Downloads") as? NSViewController else {
                    return
                }
                delegate?.changeController(vc)
            default:
                break
            }
        }
    }
}


class SelectionView: NSTableRowView {
    override func drawBackground(in _: NSRect) {
        self.isEmphasized = false
    }
}
