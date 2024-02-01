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
        
        init(plainText: Data, key: AES.Key, padding: Padding = .pkcs7) throws {
            self.padding = padding
            let enc = Self.encrypter(padding: padding)
            self.cipherText = try enc.encrypt(
                plainData: plainText,
                using: key.data
            ) ~> AES.Error.statusError
        }
        
        public func open(using key: AES.Key) throws -> Data {
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

private extension AES.Error {
    static func statusError(_ error: Error) -> Self {
        if let statusErr = error as? CommonCryptoEncrypter.StatusError {
            statusErr.code == -4303 ? Self.alignmentError : Self.statusError(code: statusErr.code)
        }else {
            Self.statusError(code: -1)
        }
    }
}
