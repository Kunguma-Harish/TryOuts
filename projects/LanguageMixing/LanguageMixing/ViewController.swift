//
//  ViewController.swift
//  LanguageMixing
//
//  Created by kunguma-14252 on 01/04/25.
//

import UIKit
import TestMyLibrary
//import TestMyLibrary

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var ren = CxxSkiaRenderer(34, 43)
        ren.printVal()
//        TestMyLibrary.
        print("sum - \(ren.sum())")
        print("diff - \(ren.diff())")
        
        // Do any additional setup after loading the view.
    }
}
