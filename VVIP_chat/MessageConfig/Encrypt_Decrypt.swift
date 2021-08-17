//
//  Encrypt_Decrypt.swift
//  VVIP_chat
//
//  Created by mac on 11/08/21.
//

import Foundation
import UIKit
import CryptoKit

func generatePrivateKey() -> P256.KeyAgreement.PrivateKey {
    let privateKey = P256.KeyAgreement.PrivateKey()
    return privateKey
}

func exportPrivateKey(_ privateKey: P256.KeyAgreement.PrivateKey) -> String {
    let rawPrivateKey = privateKey.rawRepresentation
    let privateKeyBase64 = rawPrivateKey.base64EncodedString()
    let percentEncodedPrivateKey = privateKeyBase64.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
    return percentEncodedPrivateKey
}

func importPrivateKey(_ privateKey: String) throws -> P256.KeyAgreement.PrivateKey {
    let privateKeyBase64 = privateKey.removingPercentEncoding!
    let rawPrivateKey = Data(base64Encoded: privateKeyBase64)!
    return try P256.KeyAgreement.PrivateKey(rawRepresentation: rawPrivateKey)
}

func deriveSymmetricKey(privateKey: P256.KeyAgreement.PrivateKey, publicKey: P256.KeyAgreement.PublicKey) throws -> SymmetricKey {
    let sharedSecret = try privateKey.sharedSecretFromKeyAgreement(with: publicKey)
    
    let symmetricKey = sharedSecret.hkdfDerivedSymmetricKey(
        using: SHA256.self,
        salt: "My Key Agreement Salt".data(using: .utf8)!,
        sharedInfo: Data(),
        outputByteCount: 32
    )
    
    return symmetricKey
}

func encrypt(text: String, symmetricKey: SymmetricKey) throws -> String {
    let textData = text.data(using: .utf8)!
    let encrypted = try AES.GCM.seal(textData, using: symmetricKey)
    return encrypted.combined!.base64EncodedString()
}

func decrypt(text: String, symmetricKey: SymmetricKey) -> String {
    do {
        guard let data = Data(base64Encoded: text) else {
            return "Could not decode text: \(text)"
        }
        
        let sealedBox = try AES.GCM.SealedBox(combined: data)
        let decryptedData = try AES.GCM.open(sealedBox, using: symmetricKey)
        
        guard let text = String(data: decryptedData, encoding: .utf8) else {
            return "Could not decode data: \(decryptedData)"
        }
        
        return text
    } catch let error {
        return "Error decrypting message: \(error.localizedDescription)"
    }
}

//
//func encryptMessage(message: String, encryptionKey: String) -> String {
////     let messageData = message.data(using: .utf8)!
////     let cipherData = RNCryptor.encrypt(data: messageData, withPassword: encryptionKey)
////     return cipherData.base64EncodedString()
////    let str = String(UTF8String: strToDecode.cStringUsingEncoding(NSUTF8StringEncoding))
//
//    return message.utf8EncodedString()
// }
//
// func decryptMessage(encryptedMessage: String, encryptionKey: String) throws -> String {
//
////     let encryptedData = Data.init(base64Encoded: encryptedMessage)!
////     let decryptedData = try RNCryptor.decrypt(data: encryptedData, withPassword: encryptionKey)
////     let decryptedString = String(data: decryptedData, encoding: .utf8)!
////
////     return decryptedString
//    return ""
// }
//
//extension String {
//    func utf8DecodedString()-> String {
//        let data = self.data(using: .utf8)
//        let message = String(data: data!, encoding: .nonLossyASCII) ?? ""
//        return message
//    }
//
//    func utf8EncodedString()-> String {
//        let messageData = self.data(using: .nonLossyASCII)
//        let text = String(data: messageData!, encoding: .utf8) ?? ""
//        return text
//    }
//}
