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

//func imagePreview(from moviePath: URL, in seconds: Double) -> UIImage? {
//    let timestamp = CMTime(seconds: seconds, preferredTimescale: 60)
//    let asset = AVURLAsset(url: moviePath)
//    let generator = AVAssetImageGenerator(asset: asset)
//    generator.appliesPreferredTrackTransform = true
//    
//    guard let imageRef = try? generator.copyCGImage(at: timestamp, actualTime: nil) else {
//        return nil
//    }
//    return UIImage(cgImage: imageRef)
//}
