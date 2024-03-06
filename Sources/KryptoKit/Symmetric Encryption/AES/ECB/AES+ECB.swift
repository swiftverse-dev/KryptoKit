//
//  AES+ECB.swift
//
//
//  Created by Lorenzo Limoli on 01/02/24.
//

import Foundation
import CryptoKit

public extension AES {
    struct ECB {
        private let padding: Padding
        
        public init(padding: Padding = .pkcs7) {
            self.padding = padding
        }
    }
}

extension AES.ECB: SymmetricEncrypter {
    public func seal(plainText: Data, using key: any SymmetricKey<AES>) throws -> SBox {
        try SBox(plainText: plainText, key: key, padding: padding)
    }
    
    public func sealedBox(fromCipherText cipherText: Data) -> SBox {
        SBox(cipherText: cipherText)
    }
}

