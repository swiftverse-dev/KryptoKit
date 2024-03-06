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
        
        /// CipherText + Tag
        public var cipherText: Data { encryptedText + tag }
        
        public let encryptedText: Data
        private let sbox: CryptoKit.AES.GCM.SealedBox?
        private let nonce: Nonce
        private let tag: Data
        
        init(cipherText: Data, nonce: Nonce) {
            self.init(
                encryptedText: cipherText.dropLast(AES.blockSize),
                nonce: nonce,
                tag: cipherText.suffix(AES.blockSize)
            )
        }
        
        init(encryptedText: Data, nonce: Nonce, tag: Data) {
            self.encryptedText = encryptedText
            self.nonce = nonce
            self.sbox = nil
            self.tag = tag
        }
        
        init(plainText: Data, key: any SymmetricKey<AES>, nonce: Nonce, tag: Data? = nil) throws {
            self.nonce = nonce
            let ckNonce = nonce
            let sbox = try CryptoKit.AES.GCM.seal(plainText, using: key.ckKey, nonce: ckNonce, tag: tag) ~> AES.Error.cryptoKit(error:)
            self.sbox = sbox
            
            self.encryptedText = sbox.ciphertext            
            self.tag = sbox.tag
        }
        
        public func open(using key: any SymmetricKey<AES>) throws -> Data {
            let aesKey = CryptoKit.SymmetricKey(data: key)
            let sbox = try (sbox ?? .init(nonce: nonce, ciphertext: cipherText.dropLast(AES.blockSize), tag: tag))
            return try CryptoKit.AES.GCM.open(sbox, using: aesKey) ~> AES.Error.cryptoKit(error:)
        }
    }
}

private extension SymmetricKey {
    var ckKey: CryptoKit.SymmetricKey { .init(data: self) }
}

private extension CryptoKit.AES.GCM {
    static func seal<Plaintext, AuthenticatedData>(_ message: Plaintext, using key: CryptoKit.SymmetricKey, nonce: AES.GCM.Nonce? = nil, tag: AuthenticatedData?) throws -> CryptoKit.AES.GCM.SealedBox where Plaintext : DataProtocol, AuthenticatedData : DataProtocol {
        if let tag {
            try seal(message, using: key, nonce: nonce, authenticating: tag)
        } else {
            try seal(message, using: key, nonce: nonce)
        }
    }
}
