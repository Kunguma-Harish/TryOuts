import UIKit

let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage

let imgData = NSData(data: image.jpegData(compressionQuality: 1)!)
var imageSize: Int = imgData.count
print("actual size of image in KB: %f ", Double(imageSize) / 1000.0)
