//
//  ViewController.swift
//  PickerView
//
//  Created by kunguma-14252 on 16/03/23.
//

import UIKit

class ViewController: UIViewController {
    
    let arr = ["component1", "component2", "component3", "component4", "component5", "component6", "component7", "component8"]

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var picker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        picker.isHidden = true
        self.setUpGesture()
        self.button.titleLabel?.text = arr[self.picker.selectedRow(inComponent: 0)]
        picker.delegate = self
        picker.dataSource = self
    }
    
    func setUpGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hidePicker(_:)))
        self.view.gestureRecognizers = [gesture]
    }
    
    @objc func hidePicker(_ sender: UITapGestureRecognizer? = nil) {
        self.picker.isHidden = true
    }

    @IBAction func button(_ sender: Any) {
        self.button.titleLabel?.text = arr[self.picker.selectedRow(inComponent: 0)]
        picker.isHidden = false
    }
    
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        arr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        arr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.button.titleLabel?.text = arr[row]
        print("Kungu : \(component) and \(row)")
    }
    
}
