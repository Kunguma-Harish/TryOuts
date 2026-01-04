//
//  contentView.swift
//  labelXib
//
//  Created by kunguma-14252 on 27/05/22.
//

import UIKit

@IBDesignable
class contentView: UIView {

    @IBOutlet var containerView: UIView!
    @IBOutlet weak var toastLabel: UITextView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    func setup(){
        Bundle.main.loadNibNamed("contentUi", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
    }
    
    func toastView(message: String){
        let toastTextView = self.toastLabel!
            toastTextView.textAlignment = .left
            toastTextView.backgroundColor = .black
            toastTextView.textColor = .white
            toastTextView.alpha = 1.0
            toastTextView.layer.cornerRadius = 8
            toastTextView.clipsToBounds = true
            toastTextView.textContainerInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 0)
            toastTextView.font = UIFont.systemFont(ofSize: 15.0)
            toastTextView.text = message

        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseOut, animations: {
                toastTextView.alpha = 0.0
            }, completion: nil)
    }
}
