//
//  MessageData.swift
//  VVIP_chat
//
//  Created by mac on 03/08/21.
//

import Foundation
import UIKit
import CoreLocation

struct MessageData: Codable {
    let roomId: String
    let senderId: String
    let text: String
    var isFirstUser: Bool
    let image: ImageData?
    let contact: ContactData?
    let location: Location?
    let document: URL?
    let messageType: MessageType
    let time: String
    
    init(roomId: String, senderId: String,text: String, isFirstUser: Bool, image: ImageData?,contact: ContactData?, location: Location?,document:URL?, messageType: MessageType, time: String) {
        self.roomId = roomId
        self.senderId = senderId
        self.text = text
        self.isFirstUser = isFirstUser
        self.image = image
        self.contact = contact
        self.messageType = messageType
        self.location = location
        self.document = document
        self.time = time
    }
}

struct ContactData: Codable{
    let phones: Array<String>?
//    let image: UIImage?
}

struct ImageData: Codable {
    let image: String?
    let url: URL?
}

struct Location: Codable{
    let latitude: Double?
    let longitude: Double?
}
