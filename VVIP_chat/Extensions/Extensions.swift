//
//  Extensions.swift
//  VVIP_chat
//
//  Created by mac on 28/07/21.
//

import Foundation
import UIKit

extension UIImage {


func rotate(_ radians: CGFloat) -> UIImage {
    let cgImage = self.cgImage!
    let LARGEST_SIZE = CGFloat(max(self.size.width, self.size.height))
    let context = CGContext.init(data: nil, width:Int(LARGEST_SIZE), height:Int(LARGEST_SIZE), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: cgImage.colorSpace!, bitmapInfo: cgImage.bitmapInfo.rawValue)!

    var drawRect = CGRect.zero
    drawRect.size = self.size
    let drawOrigin = CGPoint(x: (LARGEST_SIZE - self.size.width) * 0.5,y: (LARGEST_SIZE - self.size.height) * 0.5)
    drawRect.origin = drawOrigin
    var tf = CGAffineTransform.identity
    tf = tf.translatedBy(x: LARGEST_SIZE * 0.5, y: LARGEST_SIZE * 0.5)
    tf = tf.rotated(by: CGFloat(radians))
    tf = tf.translatedBy(x: LARGEST_SIZE * -0.5, y: LARGEST_SIZE * -0.5)
    context.concatenate(tf)
    context.draw(cgImage, in: drawRect)
    var rotatedImage = context.makeImage()!

    drawRect = drawRect.applying(tf)

    rotatedImage = rotatedImage.cropping(to: drawRect)!
    let resultImage = UIImage(cgImage: rotatedImage)
    return resultImage
}
}

extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

public extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
}
