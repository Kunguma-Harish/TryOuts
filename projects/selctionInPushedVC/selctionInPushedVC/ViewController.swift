//
//  ViewController.swift
//  selctionInPushedVC
//
//  Created by kunguma-14252 on 22/03/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableVIew: UITableView!
    
    var selectedteam: String = ""
    var selectedOrg: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableVIew.delegate = self
        self.tableVIew.dataSource = self
        self.tableVIew.register(UINib(nibName: "tableViewCell", bundle: nil), forCellReuseIdentifier: "tableViewCell")
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 4
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as? TableViewCellConfig else {
            return UITableViewCell()
        }
        if indexPath.section == 0 {
                cell.config(labelName: self.selectedOrg == "" ? "Zoho Corporation" : self.selectedOrg, indexPath: indexPath)
                
        }else if  indexPath.section == 1 {
            if indexPath.row == 0 {
                cell.config(labelName: "Recents", indexPath: indexPath)
            }else if indexPath.row == 1 {
                cell.config(labelName: "Favourites", indexPath: indexPath)
            }else if indexPath.row == 2 {
                cell.config(labelName: "Shared with me", indexPath: indexPath)
            }else if indexPath.row == 3 {
                cell.config(labelName: "Shared with org", indexPath: indexPath)
            }else {
                return UITableViewCell()
            }
        }else {
            cell.config(labelName: self.selectedteam == "" ? "Graphikos" : self.selectedteam, indexPath: indexPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as? TableViewCellConfig else {
            return
        }
        if indexPath.section == 0 || indexPath.section == 2 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let teamOrgViewController = storyboard.instantiateViewController(withIdentifier: "orgVC") as? TeamOrgViewController
            if indexPath.section == 0 {
                teamOrgViewController!.shouldShowOrg = true
            } else if indexPath.section == 2 {
                teamOrgViewController!.shouldShowOrg = false
            }
            teamOrgViewController?.delegate = self
            self.navigationController!.pushViewController(teamOrgViewController!, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: Selection {
    func selectedTeam(selected: String) {
        self.selectedteam = selected
        self.tableVIew.reloadData()
    }
    
    func selectedOrg(selected: String) {
        self.selectedOrg = selected
        self.tableVIew.reloadData()
    }
}
