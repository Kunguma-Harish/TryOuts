//
//  TeamOrgViewController.swift
//  selctionInPushedVC
//
//  Created by kunguma-14252 on 22/03/23.
//

import UIKit
import Foundation

class TeamOrgViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var shouldShowOrg: Bool = true
    var selectedTeam: String = "Nothing"
    
    var delegate: Selection!
    
    let org = ["Zoho Corporation", "Public Org", "Personal Team", "Personal Space"]
    let team = ["Graphikos", "Graphikos-Apple", "Graphikos-design", "Graphikos-android"]
    
    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "tableViewCell", bundle: nil), forCellReuseIdentifier: "tableViewCell")
    }
}

extension TeamOrgViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shouldShowOrg ? org.count : team.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as? TableViewCellConfig else {
            return UITableViewCell()
        }
        shouldShowOrg ? cell.config(labelName: org[indexPath.row], indexPath: indexPath, show: false) : cell.config(labelName: team[indexPath.row], indexPath: indexPath, show: false)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as? TableViewCellConfig else {
            return
        }
        self.selectedTeam = shouldShowOrg ? org[indexPath.row] : team[indexPath.row]
        shouldShowOrg ? self.delegate?.selectedOrg(selected: self.selectedTeam) : self.delegate?.selectedTeam(selected: self.selectedTeam)
        
        shouldShowOrg ? cell.config(labelName: org[indexPath.row], indexPath: indexPath, show: false,selected: true) : cell.config(labelName: team[indexPath.row], indexPath: indexPath, show: false, selected: true)
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
}


protocol Selection {
    func selectedTeam(selected: String)
    func selectedOrg(selected: String)
}
