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
    public func seal(plainText: Data, using key: AES.Key) throws -> any SealedBox<AES.Key> {
        try SBox(plainText: plainText, key: key, nonce: nonce)
    }
    
    public func sealedBox(fromCipherText cipherText: Data) -> any SealedBox<AES.Key> {
        SBox(cipherText: cipherText, nonce: nonce)
    }
    
    public func sealedBox(encryptedText: Data, tag: Data) -> SBox {
        SBox(encryptedText: encryptedText, nonce: nonce, tag: tag)
    }
}
