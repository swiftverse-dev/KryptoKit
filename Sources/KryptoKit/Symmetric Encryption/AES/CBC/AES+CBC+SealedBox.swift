//
//  AES+CBC+SealedBox.swift
//
//
//  Created by Lorenzo Limoli on 01/02/24.
//

import Foundation
import CommonCrypto

public extension AES.CBC {
    struct SBox: SealedBox {
        public let cipherText: Data
        public let iv: IV
        
        init(cipherText: Data, iv: IV) {
            self.cipherText = cipherText
            self.iv = iv
        }
        
        init(plainText: Data, key: AES.Key, iv: IV) throws {
            let enc = Self.encrypter(iv: iv)
            self.cipherText = try enc.encrypt(
                plainData: plainText,
                using: key.data
            ) ~> AES.Error.statusError
            self.iv = iv
        }
        
        public func open(using key: AES.Key) throws -> Data {
            let enc = Self.encrypter(iv: iv)
            return try enc.decrypt(encryptedData: cipherText, using: key.data)
        }
    }
}

extension AES.CBC.SBox {
    private static var algo: CCAlgorithm{ CCAlgorithm(kCCAlgorithmAES) }
    private static var mode: CCMode{ CCMode(kCCModeCBC) }
    private static func encrypter(iv: AES.CBC.IV) -> CommonCryptoEncrypter {
        CommonCryptoEncrypter(
            algo: algo,
            mode: mode,
            iv: iv.data,
            padding: CCPadding(ccPKCS7Padding)
        )
    }
}
