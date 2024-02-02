//
//  AES+CBC.swift
//
//
//  Created by Lorenzo Limoli on 01/02/24.
//

import Foundation

public extension AES {
    struct CBC {
        private let iv: IV
        
        public init(iv: Data) throws {
            self.iv = try IV(data: iv)
        }
        
        public init(iv: IV) {
            self.iv = iv
        }
    }
}

extension AES.CBC: SymmetricEncrypter {
    
    public func seal(plainText: Data, using key: AES.Key) throws -> any SealedBox<AES.Key> {
        try SBox(plainText: plainText, key: key, iv: iv)
    }
    
    public func sealedBox(fromCipherText cipherText: Data) -> any SealedBox<AES.Key> {
        SBox(cipherText: cipherText, iv: iv)
    }
}
