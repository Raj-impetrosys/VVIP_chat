//
//  Extensions.swift
//  VVIP_chat
//
//  Created by mac on 28/07/21.
//

import Foundation
import UIKit
import CoreLocation
import UniformTypeIdentifiers

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

extension UIView {
    func bindToKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func keyboardWillChange(_ notification: NSNotification){
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let beginningFrame = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        let deltaY = endFrame.origin.y - beginningFrame.origin.y

        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: curve), animations: {
            self.frame.origin.y += deltaY
        }, completion: nil)
    }
}

extension UTType {
    // Word documents are not an existing property on UTType
    static var doc: UTType {
        utType(ext: "doc")
    }
    
    static var docs: UTType {
        utType(ext: "docs")
    }
    
    static var docx: UTType {
        utType(ext: "docx")
    }
    
    static var mp4: UTType {
        utType(ext: "mp4")
    }
}

func utType(ext: String) -> UTType{
   return UTType.types(tag: ext, tagClass: .filenameExtension, conformingTo: nil).first!
}

extension UITableView {

    func scrollToBottom(){

        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }

    func scrollToTop() {

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .top, animated: true)
           }
        }
    }

    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}

extension UIView {
   func callRecursively(_ body: (_ subview: UIView) -> Void) {
      body(self)
      subviews.forEach { $0.callRecursively(body) }
   }
}

extension UIAlertController {
   func fixConstraints() -> UIAlertController {
    view.callRecursively { subview in
         subview.constraints
            .filter({ $0.constant == -16 })
            .forEach({ $0.priority = UILayoutPriority(rawValue: 999)})
    }
    return self
    }
}

//extension ChatViewController : CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first {
//            print("Location data received.")
//            print(location)
//            let alert = UIAlertController(title: "Picked location", message: "\(location)", preferredStyle: .alert)
//            present(alert, animated: true, completion: nil)
//        }
//    }
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Failed to get users location.")
//    }
//}
