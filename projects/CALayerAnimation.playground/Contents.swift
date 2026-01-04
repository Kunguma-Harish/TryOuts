//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .white
        
        let mainLayer = CALayer()
        mainLayer.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        mainLayer.backgroundColor = .init(red: 0, green: 1, blue: 0, alpha: 0.5)

        let animLayer = CALayer()
        animLayer.frame = CGRect(origin: CGPoint(x: 100,y: 100), size: CGSize(width: 200, height: 200))
        animLayer.backgroundColor = .init(red: 0, green: 0, blue: 1, alpha: 1)
        
        mainLayer.addSublayer(animLayer)

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = CGFloat.pi * 2
        rotationAnimation.toValue = 0
        rotationAnimation.duration = 2.0
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = 0

        animLayer.add(rotationAnimation, forKey: "transform.rotation.z")
        
        rotationAnimation.timeOffset = 0.3333333333 * 10
        animLayer.display()
        print("Kungu : \(animLayer.presentation()) ")
        for i in 0..<61 {
            let currentTime = Double(i) * (1.0/30.0)
            animLayer.timeOffset = currentTime
            print("Kungu : \(animLayer.frame) ")
        }
        
        view.layer.addSublayer(mainLayer)
        view.addSubview(label)
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
