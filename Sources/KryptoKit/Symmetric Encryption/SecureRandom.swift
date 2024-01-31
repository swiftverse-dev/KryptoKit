//
//  SecureRandom.swift
//
//
//  Created by Lorenzo Limoli on 31/01/24.
//

import Foundation

public enum SecureRandom{
    public enum Error: Swift.Error, Equatable{
        case badSize
        case randomErorr(code: Int)
    }
    
    public static func generate(bitSize: UInt) throws -> Data{
        if bitSize % 8 != 0{
            throw Error.badSize
        }
        
        return try generate(byteSize: bitSize / 8)
    }
    
    public static func generate(byteSize: UInt) throws -> Data{
        let byteSize = byteSize.asInt
        var bytes = [Int8](repeating: 0, count: byteSize)

        // Fill bytes with secure random data
        let status = SecRandomCopyBytes(
            kSecRandomDefault,
            byteSize,
            &bytes
        )
        
        guard status == errSecSuccess else{
            throw Error.randomErorr(code: Int(status))
        }
        
        return Data(bytes: bytes, count: byteSize)
    }
    
}

private extension UInt {
    var asInt: Int { Int(self) }
}
