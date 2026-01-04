//
//  tableViewCellConfig.swift
//  selctionInPushedVC
//
//  Created by kunguma-14252 on 22/03/23.
//

import Foundation
import UIKit

class TableViewCellConfig: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var OrgLable: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    @IBOutlet weak var afterSelection: UILabel!
    
    func config(labelName: String, indexPath: IndexPath, show: Bool = true, selected: Bool = false) {
        self.OrgLable.text = labelName
        self.arrowImageView.isHidden = !show
        if !show {
            if selected {
                self.profileImage.image = UIImage(named: "checkmark")
            }else {
                self.profileImage.image = UIImage()
            }
        }
    }
}
