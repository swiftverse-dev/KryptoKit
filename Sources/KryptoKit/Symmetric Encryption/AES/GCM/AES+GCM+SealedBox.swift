//
//  File 2.swift
//  
//
//  Created by Lorenzo Limoli on 02/02/24.
//

import Foundation
import CryptoKit

public extension AES.GCM {
    struct SBox: SealedBox {
        public let cipherText: Data
        
        private let sbox: CryptoKit.AES.GCM.SealedBox?
        private let nonce: Nonce
        
        init(cipherText: Data, nonce: Nonce) {
            self.cipherText = cipherText
            self.nonce = nonce
            self.sbox = nil
        }
        
        init(plainText: Data, key: AES.Key, nonce: Nonce) throws {
            self.nonce = nonce
            let ckNonce = nonce
            self.sbox = try CryptoKit.AES.GCM.seal(plainText, using: key.ckKey, nonce: ckNonce) ~> AES.Error.cryptoKit(error:)
            self.cipherText = sbox!.ciphertext
        }
        
        public func open(using key: AES.Key) throws -> Data {
            let aesKey = CryptoKit.SymmetricKey(data: key)
            let sbox = try (sbox ?? .init(nonce: nonce, ciphertext: cipherText, tag: Data()))
            return try CryptoKit.AES.GCM.open(sbox, using: aesKey) ~> AES.Error.cryptoKit(error:)
        }
    }
}

private extension AES.Key {
    var ckKey: CryptoKit.SymmetricKey { .init(data: self) }
}
