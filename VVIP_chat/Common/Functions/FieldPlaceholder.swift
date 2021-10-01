//
//  FieldPlaceholder.swift
//  VVIP_chat
//
//  Created by mac on 30/09/21.
//

import Foundation
import UIKit

public func placeholderText(field: UITextField,text: String){
    field.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
}
