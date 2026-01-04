//
//  ViewController.swift
//  collectionViewExpansionTryOut
//
//  Created by kunguma-14252 on 09/03/23.
//

import UIKit

class ViewController: UIViewController {
    
    let newView = UIView()

    @IBOutlet weak var buttonOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttonOutlet.backgroundColor = .systemBlue
        // Do any additional setup after loading the view.\
        newView.frame = CGRect(origin: CGPoint(
            x: self.buttonOutlet.frame.origin.x,
            y: self.buttonOutlet.frame.origin.y),
                               size: CGSize(
                width: self.buttonOutlet.frame.width,
                height: self.buttonOutlet.frame.height))
    }

    @IBAction func buttonAction(_ sender: Any) {
        newView.center = self.buttonOutlet.center
        UIView.animate(withDuration: 1, delay: 0) { [self] in
            newView.frame = CGRect(origin: CGPoint(
                x: self.buttonOutlet.frame.origin.x,
                y: self.buttonOutlet.frame.origin.y - 200),
                                   size: CGSize(
                    width: self.buttonOutlet.frame.width,
                    height: 600))
            newView.backgroundColor = .systemBlue
            self.view.addSubview(newView)
        }
    }
    
    @IBAction func reset(_ sender: Any) {
        UIView.animate(withDuration: 1, delay: 0) {
            self.newView.frame = CGRect(origin: CGPoint(
                x: self.buttonOutlet.frame.origin.x,
                y: self.buttonOutlet.frame.origin.y),
                                   size: CGSize(
                    width: self.buttonOutlet.frame.width,
                    height: self.buttonOutlet.frame.height))
            self.newView.backgroundColor = .systemBlue
            self.newView.center = self.buttonOutlet.center
        }completion: { _ in
            self.newView.removeFromSuperview()
        }
    }
    
}

