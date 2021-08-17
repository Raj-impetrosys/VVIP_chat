//
//  MessageData.swift
//  VVIP_chat
//
//  Created by mac on 03/08/21.
//

import Foundation
import UIKit
import CoreLocation

struct MessageData {
    let text: String
    let isFirstUser: Bool
    let image: imageData?
//    let contact: Array<String>?
    let contact: ContactData?
    let location: CLLocation?
    let document: URL?
    let messageType: MessageType
    
    init(text: String, isFirstUser: Bool, image: imageData?,contact: ContactData?, location: CLLocation?,document:URL?, messageType: MessageType) {
        self.text = text
        self.isFirstUser = isFirstUser
        self.image = image
        self.contact = contact
        self.messageType = messageType
        self.location = location
        self.document = document
        }
}

struct ContactData{
    let phones: Array<String>?
    let image: UIImage?
}

struct imageData {
    let image: UIImage?
    let url: URL?
}

//struct videoData {
//    let image: UIImage?
//    let url: String?
//}
