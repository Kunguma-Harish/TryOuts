//
//  ViewController.swift
//  labelXib
//
//  Created by kunguma-14252 on 27/05/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var helperView: contentView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
//        }
    }


    @IBAction func buttonClicked(_ sender: Any) {
        self.helperView.toastView(message: "URL Copied Successfully")
//        let message = "URL Copied Successfully"
//        let toastTextView = self.helperView.toastLabel!
//            toastTextView.textAlignment = .left
//            toastTextView.backgroundColor = .black
//            toastTextView.textColor = .white
//            toastTextView.alpha = 1.0
//            toastTextView.layer.cornerRadius = 8
//            toastTextView.clipsToBounds = true
////            toastTextView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 0)
//            toastTextView.font = UIFont.systemFont(ofSize: 15.0)
//            toastTextView.text = message
//
//        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseOut, animations: {
//                toastTextView.alpha = 0.0
//            }, completion: nil)
//        self.view.addSubview(helperView.containerView)
//      loadContainerView()
//        
//        let dialogMessage = UIAlertController(title: "Attention", message: "I am an alert message you cannot dissmiss.", preferredStyle: .actionSheet)
//        self.present(dialogMessage, animated: true, completion: nil)

    }
}

