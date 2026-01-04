//
//  ViewController.swift
//  nilCheckWithLabel
//
//  Created by kunguma-14252 on 21/12/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var l3: UILabel!
    @IBOutlet weak var l2: UILabel!
    @IBOutlet weak var l1: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        l1.text = ""
        l2.text = nil
        l3.text = "aaaa"
    }


}

