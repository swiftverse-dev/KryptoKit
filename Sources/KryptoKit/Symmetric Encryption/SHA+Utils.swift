//
//  SHA+Utils.swift
//
//  Created by Lorenzo Limoli on 31/01/24.
//

import Foundation
import CryptoKit

public extension String{
    var sha256Digest: SHA256Digest { SHA256.hash(data: Data(self.utf8)) }
    var sha256Data: Data { .init(sha256Digest) }
    var sha256Hex: String {
        sha256Digest.map { String(format: "%02x", $0) }.joined()
    }
    
    var sha384Digest: SHA384Digest { SHA384.hash(data: Data(self.utf8)) }
    var sha384Data: Data { .init(sha384Digest) }
    var sha384Hex: String {
        sha384Digest.map { String(format: "%02x", $0) }.joined()
    }
    
    var sha512Digest: SHA512Digest { SHA512.hash(data: Data(self.utf8)) }
    var sha512Data: Data { .init(sha512Digest) }
    var sha512Hex: String {
        sha512Digest.map { String(format: "%02x", $0) }.joined()
    }
}

public extension DataProtocol{
    var sha256Digest: SHA256Digest { SHA256.hash(data: self) }
    var sha256Data: Data { .init(sha256Digest) }
    var sha256Hex: String {
        sha256Digest.map { String(format: "%02x", $0) }.joined()
    }
    
    var sha384Digest: SHA384Digest { SHA384.hash(data: self) }
    var sha384Data: Data { .init(sha384Digest) }
    var sha384Hex: String {
        sha384Digest.map { String(format: "%02x", $0) }.joined()
    }
    
    var sha512Digest: SHA512Digest { SHA512.hash(data: self) }
    var sha512Data: Data { .init(sha512Digest) }
    var sha512Hex: String {
        sha512Digest.map { String(format: "%02x", $0) }.joined()
    }
}


