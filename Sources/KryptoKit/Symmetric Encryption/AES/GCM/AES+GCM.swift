//
//  File.swift
//  
//
//  Created by Lorenzo Limoli on 02/02/24.
//

import Foundation
import CryptoKit

public extension AES {
    struct GCM {
        private let nonce: Nonce
        
        public init(nonce: Nonce) {
            self.nonce = nonce
        }
        
        public init(nonce: Data) throws {
            self.nonce = try .init(data: nonce) ~> AES.Error.cryptoKit(error:)
        }
    }
}

extension AES.GCM: SymmetricEncrypter {
    public func seal(plainText: Data, using key: any SymmetricKey<AES>) throws -> SBox {
        try SBox(plainText: plainText, key: key, nonce: nonce)
    }
    
    public func sealedBox(fromCipherText cipherText: Data) -> SBox {
        SBox(cipherText: cipherText, nonce: nonce)
    }
    
    public func sealedBox(encryptedText: Data, tag: Data) -> SBox {
        SBox(encryptedText: encryptedText, nonce: nonce, tag: tag)
    }
}
