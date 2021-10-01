//
//  GetCurrentTime.swift
//  VVIP_chat
//
//  Created by mac on 30/09/21.
//

import Foundation

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
