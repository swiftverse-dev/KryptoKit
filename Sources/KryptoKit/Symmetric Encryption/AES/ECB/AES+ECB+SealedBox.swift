//
//  AES+ECB.swift
//
//
//  Created by Lorenzo Limoli on 01/02/24.
//

import Foundation
import CommonCrypto

public extension AES.ECB{
    struct SBox: SealedBox {
        
        public let cipherText: Data
        public let padding: Padding
        
        init(cipherText: Data, padding: Padding = .pkcs7) {
            self.cipherText = cipherText
            self.padding = padding
        }
        
        init(plainText: Data, key: any SymmetricKey<AES>, padding: Padding = .pkcs7) throws {
            self.padding = padding
            let enc = Self.encrypter(padding: padding)
            self.cipherText = try enc.encrypt(
                plainData: plainText,
                using: key.data
            ) ~> AES.Error.statusError
        }
        
        public func open(using key: any SymmetricKey<AES>) throws -> Data {
            let enc = Self.encrypter(padding: padding)
            return try enc.decrypt(encryptedData: cipherText, using: key.data) ~> AES.Error.statusError
        }
    }
}

extension AES.ECB.SBox {
    private static var algo: CCAlgorithm{ CCAlgorithm(kCCAlgorithmAES) }
    private static var mode: CCMode{ CCMode(kCCModeECB) }
    private static func encrypter(padding: AES.ECB.Padding) -> CommonCryptoEncrypter {
        CommonCryptoEncrypter(
            algo: algo,
            mode: mode,
            iv: nil,
            padding: padding.ccPadding
        )
    }
}

private extension AES.ECB.Padding {
    var ccPadding: CCPadding { CCPadding( self == .none ? ccNoPadding : ccPKCS7Padding ) }
}
