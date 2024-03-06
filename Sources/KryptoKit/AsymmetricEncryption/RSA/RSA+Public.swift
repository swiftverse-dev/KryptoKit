//
//  RSA+Public.swift
//  
//
//  Created by Lorenzo Limoli on 06/03/24.
//

import Foundation
import StorageKit

public extension RSA.Public{
    
    private init(safeSecKey secKey: SecKey) throws {
        let attributes = try (SecKeyCopyAttributes(secKey) as? [CFString: Any])
            .orThrow(RSA.Error.invalidKeyFormat)

        let isRSA = (attributes[kSecAttrKeyType] as? String) == (Keystore.KeyType.rsa.type as String)
        try isRSA.orThrow(RSA.Error.notSupportedAlgorithm)
        
        self.secKey = secKey
    }
    
    init(from data: Data) throws {
        try self.init(safeSecKey: Keystore.keyFrom(.public(.rsa, data: data)))
    }
    
    init(string key: String) throws {
        let key = RSA.trimHeaders(for: key)
        let keyData = try Data(base64Encoded: key).orThrow(RSA.Error.invalidKeyFormat)
        try self.init(from: keyData)
    }
    
}

public extension RSA.Public {
    func encrypt(data: Data) throws -> Data {
        try SecKeyIsAlgorithmSupported(secKey, .encrypt, RSA.encryptionAlgorithm)
            .orThrow(RSA.Error.notSupportedAlgorithm)
        
        return try SecKeyCreateEncryptedData(secKey, RSA.encryptionAlgorithm, data as CFData, nil)
            .orThrow(RSA.Error.encryptionError) as Data
    }
    
    func verify(signature: Data, for document: Data) throws {
        try SecKeyIsAlgorithmSupported(secKey, .verify, RSA.signatureAlgorithm)
            .orThrow(RSA.Error.notSupportedAlgorithm)
        
        return try SecKeyVerifySignature(secKey, RSA.signatureAlgorithm, document as CFData, signature as CFData, nil)
            .orThrow(RSA.Error.invalidSignature)
    }
}
