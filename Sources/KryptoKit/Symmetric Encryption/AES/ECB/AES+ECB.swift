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
        let key: AES.Key
        let padding: Padding
        
        public init(key: AES.Key, padding: Padding) {
            self.key = key
            self.padding = padding
        }
    }
}

extension AES.ECB: SymmetricEncrypter {
    public typealias Key = AES.Key
    
    
    public func seal(plainText: Data) throws -> any SealedBox<Key> {
        try SBox(plainText: plainText, key: key)
    }
    
    public func sealedBox(fromCipherText cipherText: Data) -> any SealedBox<Key> {
        SBox(cipherText: cipherText)
    }
}

