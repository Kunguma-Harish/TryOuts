//
//  ViewController.swift
//  ImageWithText
//
//  Created by kunguma-14252 on 18/01/23.
//

import UIKit

class KunguVc: UIViewController {

    @IBOutlet weak var a : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let attachment = NSTextAttachment(image: UIImage(named: "shape")!)
        attachment.bounds = CGRect(x: 0, y: -2, width: 13, height: 13)
        let attachmentString = NSAttributedString(attachment: attachment)
        let commentContent =  NSAttributedString(string: "Kunguma Harish")
        let commentContainsImage = NSMutableAttributedString(attributedString: attachmentString)
        commentContainsImage.append(NSAttributedString(string: " "))
        commentContainsImage.append(commentContent)
        self.a.attributedText = commentContainsImage
    }


}

