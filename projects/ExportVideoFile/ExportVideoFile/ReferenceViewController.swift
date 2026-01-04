//
//  ReferenceViewController.swift
//  ExportVideoFile
//
//  Created by Kamatchi Sundaram G on 12/07/22.

import UIKit
import AVFoundation

class ReferenceViewController: UIViewController {
    private let videoExporter: VideoExporter = VideoExporter()
    
    @IBAction func buttonAction(_ sender: Any) {
        addShapeLayer()
    }
    
    @IBAction func exportAction(_ sender: Any) {
        exportAnimation()
    }
    
    @IBOutlet weak var canvasView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let destinationFrame = AVMakeRect(aspectRatio: CGSize(width: 960, height: 540), insideRect: self.view.bounds.insetBy(dx: 10, dy: 10))
        self.canvasView.frame = CGRect(x: (self.view.bounds.width - destinationFrame.width) / 2, y: (self.view.bounds.height - destinationFrame.height) / 2, width: destinationFrame.width, height: destinationFrame.height)
        self.canvasView.backgroundColor = .lightGray
    }
    
    func addShapeLayer() {
        let randomX = Int.random(in: 0...Int(canvasView.frame.width) - 100)
        let randomY = Int.random(in: 0...Int(canvasView.frame.height) - 100)
        let randomWidth = 100
        let randomHeight = 100
        
        let color = UIColor(red: CGFloat(Float.random(in: 0...1)), green: CGFloat(Float.random(in: 0...1)), blue: CGFloat(Float.random(in: 0...1)), alpha: 1)
        let shapeLayer = MyLayer()

        let randomNum = Int.random(in: 0...2)
        
        switch randomNum{
        case 0:
            shapeLayer.shapeIdentifier = .oval
        case 1:
            shapeLayer.shapeIdentifier = .triangle
        case 2:
            shapeLayer.shapeIdentifier = .rect
        default:
            shapeLayer.shapeIdentifier = .rect
        }
        
        let randomAnimation = Int.random(in: 0...2)
        
        switch randomAnimation{
        case 0:
            shapeLayer.animationGetter = .shake
        case 1:
            shapeLayer.animationGetter = .scale
        default:
            shapeLayer.animationGetter = .scale
        }
        
        let path = shapeLayer.shapeIdentifier.path(for: CGSize(width: randomWidth, height: randomHeight))
        shapeLayer.path = path
        shapeLayer.fillColor = color.cgColor
        shapeLayer.frame = CGRect(origin: CGPoint(x: randomX, y: randomY), size: CGSize(width: randomWidth, height: randomHeight))
        
        shapeLayer.add(shapeLayer.animationGetter.animate(with: shapeLayer.frame), forKey: "spring")
        self.canvasView.layer.addSublayer(shapeLayer)
    }
    
    func exportAnimation() {
        let outputSize = CGSize(width: 960, height: 540)
        
        let parentLayer = CALayer()
        parentLayer.frame = CGRect(origin: .zero, size: outputSize)
        
        var startTime: CFTimeInterval = .zero
        if let layers = self.canvasView.layer.sublayers {
            let canvasFrame = self.canvasView.frame
            let widthRatio = outputSize.width / canvasFrame.width
            let heightRatio = outputSize.height / canvasFrame.height
            
            for layer in layers {
                if let shapeLayer = layer as? MyLayer {
                    let shapeLayerFrame = shapeLayer.frame
                    let destinationWidth = shapeLayerFrame.width * widthRatio
                    let destinationHeight = shapeLayerFrame.height * heightRatio
                    
                    
                    let layerPath = shapeLayer.shapeIdentifier.path(for: CGSize(width: destinationWidth, height: destinationHeight))
                    
                    let animatingLayer = CAShapeLayer()
                    animatingLayer.fillColor = shapeLayer.fillColor
                    animatingLayer.path = layerPath
                    animatingLayer.frame = CGRect(
                        origin: CGPoint(
                            x: shapeLayerFrame.minX * widthRatio,
                            y: shapeLayerFrame.minY * heightRatio
                        ),
                        size: CGSize(
                            width: destinationWidth,
                            height: destinationHeight
                        )
                    )
                    
                    let opacityAnimation = CABasicAnimation()
                    opacityAnimation.keyPath = "opacity"
                    opacityAnimation.fromValue = 0
                    opacityAnimation.toValue = 0
                    opacityAnimation.duration = startTime
                    opacityAnimation.beginTime = AVCoreAnimationBeginTimeAtZero
                    animatingLayer.add(opacityAnimation, forKey: "opacity")
                    
                    let layerAnimation = shapeLayer.animationGetter.animate(with: animatingLayer.frame)
                    layerAnimation.beginTime = AVCoreAnimationBeginTimeAtZero + startTime
                    startTime += layerAnimation.duration
                    animatingLayer.add(layerAnimation, forKey: "animation")
                    parentLayer.addSublayer(animatingLayer)
                }
            }
        }
        self.videoExporter.exportAnimation(animatingLayer: parentLayer, videoSize: outputSize) { url in
            print("Subramanian:- Completed export - \(String(describing: url))")
            let activityViewController = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
            self.present(activityViewController, animated: true)
        }
    }
}
enum Shape {
    case rect
    case oval
    case triangle
    
    func path(for size: CGSize) -> CGPath {
        switch self {
        case .rect:
            return UIBezierPath(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height)).cgPath
        case .oval:
            return UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: size.width, height: size.height)).cgPath
        case .triangle:
            let trianglePath = UIBezierPath()
            trianglePath.move(to: CGPoint(x: 0, y: 0))
            trianglePath.addLine(to: CGPoint(x: size.width/2, y: size.height))
            trianglePath.addLine(to: CGPoint(x: size.width, y: 0))
            trianglePath.addLine(to: CGPoint(x: 0, y: 0))
            return trianglePath.cgPath
        }
    }
}
enum Animation {
    case shake
    case scale
    
    func animate(with frame:CGRect) -> CAAnimation{
        switch self {
        case .shake:
            let animation = CASpringAnimation(keyPath: "position.x")
            animation.damping = 10
            animation.fromValue = frame.midX + 50
            animation.toValue = frame.midX
            animation.duration = animation.settlingDuration
            return animation
        case .scale:
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = 0.8
            scaleAnimation.toValue = 1.2
            scaleAnimation.duration = 3
            scaleAnimation.repeatCount = .zero
            scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            return scaleAnimation
        }
    }
}
class MyLayer:CAShapeLayer {
    var shapeIdentifier:Shape = .triangle
    
    var animationGetter:Animation = .shake
}
