//
//  base64Image.swift
//  VVIP_chat
//
//  Created by mac on 29/09/21.
//

import Foundation
import UIKit

func imageToBase64(image: UIImage?)-> String?{
    guard let base64EncodedImage = image?.jpegData(compressionQuality: 0.0)?.base64EncodedString() else { return nil }
    return base64EncodedImage
}

func base64ToImage(base64String: String?)-> UIImage?{
    let newImageData = Data(base64Encoded: base64String!)
    guard let image = UIImage(data: newImageData!) else {
        return nil
    }
    return image
}
