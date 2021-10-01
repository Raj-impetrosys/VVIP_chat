//
//  GetFileSize.swift
//  VVIP_chat
//
//  Created by mac on 30/09/21.
//

import Foundation

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
