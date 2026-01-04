//
//  ViewController.swift
//  slideToZoom
//
//  Created by kunguma-14252 on 22/02/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b3: UIButton!
    @IBOutlet weak var b4: UIButton!
    @IBOutlet weak var b5: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imageView.image =  UIImage(named: "4ktest")
        self.slider.minimumValue = 0.1
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 10
    }
    
    func scrollTo(zoomScale: CGFloat) {
        let vWidth = self.view.frame.width
        let vHeight = self.view.frame.height

        let scrollImg: UIScrollView = self.scrollView
        scrollImg.delegate = self
        scrollImg.frame = CGRectMake(0,0, vWidth, vHeight)
        scrollImg.flashScrollIndicators()

        scrollImg.zoomScale = zoomScale
    }
    
    @IBAction func sliderAction(_ sender: UISlider) {
        let trackRect = sender.trackRect(forBounds: sender.frame)
        let thumbRect = sender.thumbRect(forBounds: sender.bounds, trackRect: trackRect, value: sender.value)
        self.label.center = CGPoint(x: thumbRect.midX, y: self.label.center.y)
        self.label.text = "\(Int(slider.value * 100))"
        self.scrollTo(zoomScale: CGFloat(slider.value * 10))
    }
    
    @IBAction func b1(_ sender: Any) {
        self.scrollTo(zoomScale: 0)
    }
    
    @IBAction func b2(_ sender: Any) {
        self.scrollTo(zoomScale: 2.5)
    }
    
    @IBAction func b3(_ sender: Any) {
        self.scrollTo(zoomScale: 5)
    }

    @IBAction func b4(_ sender: Any) {
        self.scrollTo(zoomScale: 7.5)
    }
    
    @IBAction func b5(_ sender: Any) {
        self.scrollTo(zoomScale: 10)
    }
}


extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.slider.value = Float(self.scrollView.zoomScale * 0.1)
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
