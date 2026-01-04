//
//  ViewController.swift
//  labelCornerRadius
//
//  Created by kunguma-14252 on 14/12/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var bgiVew: UIView!
    @IBOutlet weak var label: UILabel!
    
    
    @IBOutlet weak var secView: UIView!
    @IBOutlet weak var secLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.label.text = "The following code shows the viewDidAppear(_:) method of the container view controller that extends the safe area of its child view controller to account for the custom views, as shown in the image. Make your modifications in this method because the safe area insets for a view aren’t accurate until the view is added to a view hierarchy."
        self.secView.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.segment.selectedSegmentIndex == 2 {
            self.secView.layer.cornerRadius = self.secView.frame.height / 2
        }
    }

    @IBAction func segmentAction(_ sender: Any) {
        switch self.segment.selectedSegmentIndex {
            
        case 0:
            self.bgiVew.isHidden = false
            self.secView.isHidden = false
            self.label.text = "The following code shows the viewDidAppear(_:) method of the container view controller that extends the safe area of its child view controller to account for the custom views, as shown in the image. Make your modifications in this method because the safe area insets for a view aren’t accurate until the view is added to a view hierarchy."
            self.bgiVew.layer.cornerRadius = 0
            self.secLabel.text = "Hello"
            self.label.sizeToFit()
            self.secView.layoutSubviews()
//            self.bgiVew.sizeToFit()            self.secView.layer.cornerRadius = self.secView.frame.height / 2
            
            
        case 1:
            self.bgiVew.isHidden = false
            self.secView.isHidden = true
            self.label.text = "The following code shows the viewDidAppear(_:) method of the container view controller that extends the safe area of its child view controller to account for the custom views, as shown in the image. Make your modifications in this method because the safe area insets for a view aren’t accurate until the view is added to a view hierarchy."
            self.bgiVew.layer.cornerRadius = 0
            
        default:
            self.secView.isHidden = false
            self.bgiVew.isHidden = true
            self.secLabel.text = "Hello"
            self.label.sizeToFit()
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
}

