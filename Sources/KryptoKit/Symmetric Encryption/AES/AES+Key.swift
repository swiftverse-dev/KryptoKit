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
    static func k128() -> Self {
        Self(data: random(byteSize: aes128))
    }
    
    static func k192() -> Self {
        Self(data: random(byteSize: aes192))
    }
    
    static func k256() -> Self {
        Self(data: random(byteSize: aes256))
    }
}


private extension AES.Key {
    static func random(byteSize: Int) -> Data {
        var password = try! SecureRandom.generate(byteSize: UInt(byteSize))
        var salt = try! SecureRandom.generate(byteSize: 8)
        let byteSize = Int(byteSize)
        
        var derivedKey = [UInt8](repeating: 0, count: byteSize)
        let algo = CCPBKDFAlgorithm(kCCPBKDF2)
        withUnsafeBytes(of: &password) { [password] passwordBytes in
            withUnsafeBytes(of: &salt) { [salt] saltBytes in
                CCKeyDerivationPBKDF(
                    algo,
                    passwordBytes.assumingMemoryBound(to: CChar.self).baseAddress,
                    password.count,
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
    
    static func fromPassword(_ password: String) throws -> Data {
        Data()
    }
}
