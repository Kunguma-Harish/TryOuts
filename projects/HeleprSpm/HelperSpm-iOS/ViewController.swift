//
//  ViewController.swift
//  HelperSpm-iOS
//
//  Created by kunguma-14252 on 20/06/24.
//

import UIKit
import Proto

class ViewController: UIViewController {

    @IBAction private func actionButtonClick(_ sender: UIButton) {
//        EditorVC.execute()
//        
//        guard let vc = UIStoryboard().initialVC else {
//            return
//        }
//        present(vc, animated: true)
        let doc = Document.ScreenOrShapeElement()
        print(doc)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
