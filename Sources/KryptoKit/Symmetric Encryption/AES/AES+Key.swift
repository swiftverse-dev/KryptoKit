//
//  AES+Key.swift
//
//
//  Created by Lorenzo Limoli on 31/01/24.
//

import Foundation
import CommonCrypto

public extension AES {
    struct Key: Equatable, Hashable {
        static let aes128 = kCCKeySizeAES128
        static let aes192 = kCCKeySizeAES192
        static let aes256 = kCCKeySizeAES256
        
        public let data: Data
        public var size: Int { data.count }
        public var bitSize: Int { data.count * 8 }
        
        fileprivate init(data: Data) {
            self.data = data
        }
    }
}


public extension AES.Key {
    static func k128(derivedFrom password: String? = nil, salt: Data? = nil) -> Self {
        if let password{
            return Self(data: fromPassword(password, salt: salt, byteSize: aes128))
        }
        return Self(data: random(byteSize: aes128))
    }
    
    static func k192(derivedFrom password: String? = nil, salt: Data? = nil) -> Self {
        if let password{
            return Self(data: fromPassword(password, salt: salt, byteSize: aes192))
        }
        return Self(data: random(byteSize: aes192))
    }
    
    static func k256(derivedFrom password: String? = nil, salt: Data? = nil) -> Self {
        if let password{
            return Self(data: fromPassword(password, salt: salt, byteSize: aes256))
        }
        return Self(data: random(byteSize: aes256))
    }
}


private extension AES.Key {
    static func random(byteSize: Int) -> Data {
        let password = try! SecureRandom.generate(byteSize: UInt(byteSize))
        let salt = try! SecureRandom.generate(byteSize: 8)
        
        return deriveKeyFrom(password: password, passwordCount: \.count, salt: salt, byteSize: byteSize)
    }
    
    static func fromPassword(_ password: String, salt: Data?, byteSize: Int) -> Data {
        let salt = try! (salt ?? SecureRandom.generate(byteSize: 8))
        return deriveKeyFrom(password: password, passwordCount: \.count, salt: salt, byteSize: byteSize)
    }
    
    static func deriveKeyFrom<Password>(password: Password, passwordCount: KeyPath<Password, Int>, salt: Data, byteSize: Int) -> Data {
        var password = password
        var salt = salt
        
        var derivedKey = [UInt8](repeating: 0, count: byteSize)
        withUnsafeBytes(of: &password) { [password] passwordBytes in
            withUnsafeBytes(of: &salt) { [salt] saltBytes in
                CCKeyDerivationPBKDF(
                    CCPBKDFAlgorithm(kCCPBKDF2),
                    passwordBytes.assumingMemoryBound(to: CChar.self).baseAddress,
                    password[keyPath: passwordCount],
                    saltBytes.assumingMemoryBound(to: UInt8.self).baseAddress,
                    salt.count,
                    CCPBKDFAlgorithm(kCCPRFHmacAlgSHA1),
                    10000,
                    &derivedKey,
                    byteSize
                )
                return
            }
        }
        
        return Data(bytes: derivedKey, count: byteSize)
    }
}
