//
//  SecKey+Asn1.swift
//
//
//  Created by Lorenzo Limoli on 06/03/24.
//

import Foundation
import StorageKit

public extension SecKey{
    private static let privateKeyHeader = "-----BEGIN PRIVATE KEY-----"
    private static let privateKeyFooter = "-----END PRIVATE KEY-----"
    private static let publicKeyHeader  = "-----BEGIN PUBLIC KEY-----"
    private static let publicKeyFooter  = "-----END PUBLIC KEY-----"
    
    private static var asn1Header: [UInt8] {
        [
            0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
            0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00
        ]
    }
    
    func pemString(privateKey: Bool) -> String?{
        guard let plainData = data else { return nil }
        
        var finalData = Data()
        if !privateKey{
            finalData.append(Data(Self.asn1Header))
        }
        finalData.append(contentsOf: plainData)

        let pkcs1Base64 = finalData.base64EncodedString(options: [.lineLength64Characters, .endLineWithLineFeed])
        
        let header = privateKey ? Self.privateKeyHeader : Self.publicKeyHeader
        let footer = privateKey ? Self.privateKeyFooter : Self.publicKeyFooter

        return "\(header)\n\(pkcs1Base64)\n\(footer)"
    }
}
