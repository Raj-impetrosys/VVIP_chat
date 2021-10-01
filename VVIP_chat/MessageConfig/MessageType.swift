//
//  MessageType.swift
//  VVIP_chat
//
//  Created by mac on 10/08/21.
//

import Foundation
import UIKit

public enum MessageType: String, Codable {
    case text
    case attributedText
    case image
    case video
    case location
    case emoji // include in text
    case audio
    case contact
    case link
    case document
    case custom
}
