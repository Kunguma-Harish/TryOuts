////
////  ViewController.swift
////  ExportVideoFile
////
////  Created by Kamatchi Sundaram G on 11/07/22.
////
//
//import UIKit
//import AVFoundation
//
//class ViewController: UIViewController {
//    
//    
//    let spring = CASpringAnimation(keyPath: "position.y")
//    
//    let parentLayer = CALayer()
//    let videoLayer = CALayer()
//    let composition = AVMutableComposition()
//    let videoCompositionAV = AVMutableVideoComposition()
//    let instructionAV = AVMutableVideoCompositionInstruction()
//    let randomY = Int.random(in: 0...100)
//    let assetURL = Bundle.main.url(forResource: "leaf", withExtension: "mp4")
//    
//    
//    
//    @IBAction func exportAction(_ sender: Any) {
//        export()
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setLayer()
//    }
//    
//    func setLayer(){
//        let AVItem = AVURLAsset(url: assetURL!)
//        let layer = CALayer()
//        layer.backgroundColor = UIColor.blue.cgColor
//        layer.frame = CGRect(x: 200, y: 300, width: 150, height: 150)
//        view.layer.addSublayer(parentLayer)
//        spring.damping = 5
//        spring.toValue = layer.position.y
//        spring.fromValue = layer.position.y + 100
//        spring.duration = spring.settlingDuration
//        layer.add(spring, forKey: "spring")
//        
//        
//        parentLayer.frame = CGRect(x: 20, y: 300, width: 150, height: 150)
//        videoLayer.frame = CGRect(x: 20, y: 300, width: 150, height: 150)
//        parentLayer.addSublayer(videoLayer)
//        parentLayer.addSublayer(layer)
//        
//        let compositionVideoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
//        let sourceTrack = AVItem.tracks(withMediaType: .video).first!
//        print(sourceTrack)
//        print(AVItem.tracks(withMediaType: .video))
//        do{
//            let timeRange = CMTimeRange(start: .zero, duration: AVItem.duration)
//            try compositionVideoTrack?.insertTimeRange(timeRange, of: sourceTrack, at: CMTime.zero)
////            compositionVideoTrack?.scaleTimeRange(timeRange, toDuration: CMTime(seconds: 10, preferredTimescale: 2))
//        }
//        catch {
//            print(Error.self)
//        }
//        composition.naturalSize = CGSize(width: 300, height: 600)
//        
//        
//        instructionAV.timeRange.start = CMTime.zero
//        instructionAV.timeRange.duration = CMTime(seconds: 20, preferredTimescale: 1)
//        
//        
//        videoCompositionAV.frameDuration = CMTime(seconds: 10, preferredTimescale: 1)
//        videoCompositionAV.renderSize = CGSize(width: 300, height: 600)
//        videoCompositionAV.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: layer)
//        videoCompositionAV.instructions = [instructionAV]
//    
//        
//        
//    }
//    func export(){
//        
//        let exportURL = URL(fileURLWithPath: NSTemporaryDirectory())
//            .appendingPathComponent("\(randomY)anim2Video")
//            .appendingPathExtension("mov")
//        
//        let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)
//        exporter?.outputURL = exportURL
//        exporter?.outputFileType = AVFileType.mp4
//        exporter?.shouldOptimizeForNetworkUse = true
//        exporter?.videoComposition = videoCompositionAV
//        exporter?.exportAsynchronously(completionHandler: {
//            () -> Void in
//            if exporter?.status == .completed{
//                print("success")
//                UISaveVideoAtPathToSavedPhotosAlbum(exportURL.path, nil, nil, nil)
//            }else if exporter?.status == .failed{
//                print(exportURL)
//                print(exporter?.error)
//                print("failed")
//            }
//            
//        })
//    }
//}
//
//
//
//
