//
//  GenerateThumbnail.swift
//  VVIP_chat
//
//  Created by mac on 30/09/21.
//

import Foundation
import AVFoundation
import UIKit

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
