//
//  func.swift
//  VVIP_chat
//
//  Created by mac on 12/08/21.
//

import Foundation
import UIKit
import AVFoundation

public func saveData(key: String, data: Any){
    let userDefaults = UserDefaults.standard
    userDefaults.set(data, forKey: key)
    userDefaults.synchronize()
}

public func getData(key: String) -> Any{
    let data: String = UserDefaults.standard.string(forKey: key)!
    return data
}

public func generateThumbnail(path: URL) -> UIImage? {
    do {
        let asset = AVURLAsset(url: path, options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
        let thumbnail = UIImage(cgImage: cgImage)
        return thumbnail
    } catch let error {
        print("*** Error generating thumbnail: \(error.localizedDescription)")
        return nil
    }
}

public func generateThumbnail1(url: URL) -> UIImage? {
    do {
        let asset = AVURLAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        // Select the right one based on which version you are using
        // Swift 4.2
        //        let cgImage = try imageGenerator.copyCGImage(at: .zero,
        //                                                     actualTime: nil)
        let cgImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 20, timescale: 5) , actualTime: nil)
        // Swift 4.0
        //        let cgImage = try imageGenerator.copyCGImage(at: kCMTimeZero,
        //                                                     actualTime: nil)
        
        
        return UIImage(cgImage: cgImage)
    } catch {
        print(error.localizedDescription)
        
        return nil
    }
    //    DispatchQueue.global().async {
    //        let asset = AVAsset(url: url)
    //        let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
    //         assetImgGenerate.appliesPreferredTrackTransform = true
    //        let time = CMTimeMake(value: 1, timescale: 2)
    //        let img = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)
    //        if img != nil {
    //        let frameImg  = UIImage(cgImage: img!)
    //                        DispatchQueue.main.async(execute: {
    //        // assign your image to UIImageView
    //                        })
    //                }
    //        }
}

func imagePreview(from moviePath: URL, in seconds: Double) -> UIImage? {
    let timestamp = CMTime(seconds: seconds, preferredTimescale: 60)
    let asset = AVURLAsset(url: moviePath)
    let generator = AVAssetImageGenerator(asset: asset)
    generator.appliesPreferredTrackTransform = true
    
    guard let imageRef = try? generator.copyCGImage(at: timestamp, actualTime: nil) else {
        return nil
    }
    return UIImage(cgImage: imageRef)
}

func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
    DispatchQueue.global().async { //1
        let asset = AVAsset(url: url) //2
        let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
        avAssetImageGenerator.appliesPreferredTrackTransform = true //4
        let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
        do {
            let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
            let thumbImage = UIImage(cgImage: cgThumbImage) //7
            DispatchQueue.main.async { //8
                completion(thumbImage) //9
            }
        } catch {
            print(error.localizedDescription) //10
            DispatchQueue.main.async {
                completion(nil) //11
            }
        }
    }
}

func sizeForLocalFilePath(filePath:String) -> UInt64 {
    do {
        let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
        if let fileSize = fileAttributes[FileAttributeKey.size]  {
            return (fileSize as! NSNumber).uint64Value
        } else {
            print("Failed to get a size attribute from path: \(filePath)")
        }
    } catch {
        print("Failed to get file attributes for local path: \(filePath) with error: \(error)")
    }
    return 0
}

func fileSize(fromPath path: String) -> String? {
    guard let size = try? FileManager.default.attributesOfItem(atPath: path)[FileAttributeKey.size],
          let fileSize = size as? UInt64 else {
        return nil
    }
    
    // bytes
    if fileSize < 1023 {
        return String(format: "%lu bytes", CUnsignedLong(fileSize))
    }
    // KB
    var floatSize = Float(fileSize / 1024)
    if floatSize < 1023 {
        return String(format: "%.1f KB", floatSize)
    }
    // MB
    floatSize = floatSize / 1024
    if floatSize < 1023 {
        return String(format: "%.1f MB", floatSize)
    }
    // GB
    floatSize = floatSize / 1024
    return String(format: "%.1f GB", floatSize)
}

func getTime() -> String {
    //    let date = Date()
    //    let time:DateComponents! = Calendar.current.dateComponents([.hour, .minute, .calendar, .day, .month, .year], from: date)
    
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "h:mm a"
    formatter.amSymbol = "AM"
    formatter.pmSymbol = "PM"
    
    let dateString = formatter.string(from: Date())
    //    let sendTime = String(describing: "\(String(describing: time.hour)):\(String(describing: time.minute))")
    //    let sendTime = "\(time.hour!):\(time.minute!) AM"
    //    print(sendTime) // may print: Optional(13)
    return dateString
}

public func placeholderText(field: UITextField,text: String){
    field.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
