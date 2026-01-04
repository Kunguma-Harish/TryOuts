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
        label.textColor = .black
        
        view.addSubview(label)
        
        let cloudPath = UIBezierPath()
        let cloudCenter = CGPoint(x: 100, y: 100) // the center point of the cloud
        let cloudRadius: CGFloat = 50 // the radius of the cloud

        // Draw the cloud shape
        cloudPath.addArc(withCenter: CGPoint(x: cloudCenter.x - cloudRadius, y: cloudCenter.y), radius: cloudRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        cloudPath.addArc(withCenter: CGPoint(x: cloudCenter.x, y: cloudCenter.y - cloudRadius), radius: cloudRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        cloudPath.addArc(withCenter: CGPoint(x: cloudCenter.x + cloudRadius, y: cloudCenter.y), radius: cloudRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        cloudPath.addArc(withCenter: CGPoint(x: cloudCenter.x, y: cloudCenter.y + cloudRadius), radius: cloudRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)

        // Close the path to complete the cloud shape
        cloudPath.close()

        // Set the fill color and stroke color of the path
        UIColor.white.setFill()
        UIColor.gray.setStroke()

        // Fill and stroke the path
        cloudPath.fill()
        cloudPath.stroke()
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 100, y: 100),
                                       radius: 50,
                                       startAngle: 0,
                                       endAngle: CGFloat(Double.pi * 2),
                                       clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = cloudPath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2.0
        
        view.layer.addSublayer(shapeLayer)
        
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
