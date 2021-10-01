//
//  socketData.swift
//  VVIP_chat
//
//  Created by mac on 23/09/21.
//

import Foundation
import UIKit

struct Socket1Data: Codable {
    let roomId: String
    let senderId: String
    let text: String
    let isFirstUser: Bool
    let image: ImageData?
    let contact: ContactData?
    let location: Location?
    let document: String?
    let messageType: MessageType
    let time: String
    
    init(roomId: String, senderId: String,text: String, isFirstUser: Bool, image: ImageData?,contact: ContactData?, location: Location?,document:String?, messageType: MessageType, time: String) {
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

//struct Image: Codable{
//    let image: String?
//    let url: URL?
//}
