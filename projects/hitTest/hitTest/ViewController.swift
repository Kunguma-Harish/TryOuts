//
//  ViewController.swift
//  hitTest
//
//  Created by kunguma-14252 on 13/03/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .lightGray
        
        let view1 = CustomView(frame: CGRect(origin: self.view.center, size: CGSize(width: 100, height: 100)))
        view1.backgroundColor = .systemBlue
        self.view.addSubview(view1)
        
        let view2 = CustomView(frame: CGRect(origin: self.view.center, size: CGSize(width: 120, height: 120)))
        view2.backgroundColor = .systemPink
        view1.addSubview(view2)
        
        let view3 = CustomView(frame: CGRect(origin: self.view.center, size: CGSize(width: 140, height: 140)))
        view3.backgroundColor = .systemYellow
        view2.addSubview(view3)
        
        print("Kungu ViewController: \(view1.hitTest(CGPoint(x: 100, y: 100), with: nil))")
    }


}
