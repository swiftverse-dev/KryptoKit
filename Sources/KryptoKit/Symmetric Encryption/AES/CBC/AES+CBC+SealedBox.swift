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
        public var cipherText: Data
        
        init(cipherText: Data) {
            self.cipherText = cipherText
        }
        
        init(plainText: Data, key: AES.Key) throws {
            let enc = Self.encrypter()
            self.cipherText = try enc.encrypt(
                plainData: plainText,
                using: key.data
            ) ~> AES.Error.statusError
        }
        
        public func open(using key: AES.Key) throws -> Data {
            Data()
        }
    }
}

extension AES.CBC.SBox {
    private static var algo: CCAlgorithm{ CCAlgorithm(kCCAlgorithmAES) }
    private static var mode: CCMode{ CCMode(kCCModeCBC) }
    private static func encrypter() -> CommonCryptoEncrypter {
        CommonCryptoEncrypter(
            algo: algo,
            mode: mode,
            iv: nil,
            padding: CCPadding(ccPKCS7Padding)
        )
    }
}
