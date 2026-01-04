import PlaygroundSupport
import MetalKit

    guard let metalDevice = MTLCreateSystemDefaultDevice() else {
        assertionFailure("Failed")
    }

    let frame: CGRect = .init(origin: .zero, size: CGSize(width: 500, height: 500))
    let metalView: MTKView = .init(frame: frame, device: metalDevice)
    metalView.clearColor = MTLClearColor(red: 1, green: 1, blue: 0.8, alpha: 1)

    let meshAllocator = MTKMeshBufferAllocator(device: metalDevice)


    PlaygroundPage.current.liveView = metalView
//} else {
//    print("Kungu -- Failed to create device.")
//}
