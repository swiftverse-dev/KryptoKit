//
//  RSA+Private.swift
//
//
//  Created by Lorenzo Limoli on 06/03/24.
//

import Foundation
import StorageKit

public extension RSA{
    struct Private: PrivateKey {
        public typealias Algorithm = RSA
                
        public let secKey: SecKey
        public var pem: String? { secKey.pemString(privateKey: true) }
        
        public init(bitSize: Int, storingTo store: (Keystore, tag: String)? = nil) throws {
            guard let store else {
                self.secKey = try Keystore.generate(key: .rsa(bitSize: bitSize))
                return
            }
            
            let keystore = store.0
            self.secKey = try keystore.generate(key: .rsa(bitSize: bitSize), forTag: store.tag)
        }
        
        public init(from data: Data, storingTo store: (Keystore, tag: String)? = nil) throws {
            guard let store else {
                self.secKey = try Keystore.keyFrom(.private(.rsa, data: data))
                return
            }
            
            let keystore = store.0
            self.secKey = try keystore.keyFrom(.private(.rsa, data: data), storingWithTag: store.tag)
        }
        
        public init(string key: String, storingTo store: (Keystore, tag: String)? = nil) throws {
            let key = RSA.trimHeaders(for: key)
            let keyData = try Data(base64Encoded: key).orThrow(RSA.Error.invalidKeyFormat)
            try self.init(from: keyData, storingTo: store)
        }
        
        public init(loadingFrom keystore: Keystore, tag: String) throws {
            let secKey = try keystore.loadKey(for: tag)
            let attributes = try (SecKeyCopyAttributes(secKey) as? [CFString: Any])
                .orThrow(RSA.Error.invalidKeyFormat)
    
            let isRSA = (attributes[kSecAttrKeyType] as? String) == (Keystore.KeyType.rsa.type as String)
            
            try isRSA.orThrow(RSA.Error.notSupportedAlgorithm)
            
            self.secKey = secKey
        }
        
        public func publicKey() throws -> RSA.Public {
            let pubKey = try Keystore.extractPublicKey(from: secKey)
            return RSA.Public(key: pubKey)
        }
    }
}


public extension RSA.Private {
    func decrypt(cipherText: Data) throws -> Data {
        try SecKeyIsAlgorithmSupported(secKey, .decrypt, RSA.encryptionAlgorithm)
            .orThrow(RSA.Error.notSupportedAlgorithm)
        
        return try SecKeyCreateDecryptedData(secKey, RSA.encryptionAlgorithm, cipherText as CFData, nil)
            .orThrow(RSA.Error.decryptionError) as Data
    }
    
    func sign(_ document: Data) throws -> Data {
        try SecKeyIsAlgorithmSupported(secKey, .sign, RSA.signatureAlgorithm)
            .orThrow(RSA.Error.notSupportedAlgorithm)
        
        return try SecKeyCreateSignature(secKey, RSA.signatureAlgorithm, document as CFData, nil)
            .orThrow(RSA.Error.signingError) as Data
    }
}

public extension RSA{
    struct Public: PublicKey {
        public typealias Algorithm = RSA
        
        public let secKey: SecKey
        public var pem: String? { secKey.pemString(privateKey: false) }
        
        fileprivate init(key: SecKey) {
            self.secKey = key
        }
                
    }
}
