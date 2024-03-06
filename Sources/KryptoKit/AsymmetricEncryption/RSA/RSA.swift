//
//  RSA.swift
//
//
//  Created by Lorenzo Limoli on 06/03/24.
//

import Foundation

public enum RSA: AsymmetricAlgorithm {
    public static var encryptionAlgorithm: SecKeyAlgorithm { .rsaEncryptionPKCS1 }
    public static var signatureAlgorithm: SecKeyAlgorithm { .rsaSignatureMessagePKCS1v15SHA256 }
    
    public enum Error: Swift.Error {
        case encryptionError
        case decryptionError
        case notSupportedAlgorithm
        case invalidKeyFormat
        case signingError
        case invalidSignature
    }
    
    static func trimHeaders(for pemKey: String) -> String { pemKey.trimHeaders() }
}

private extension String {
    func trimHeaders() -> String{
        let newKey = removingRegexMatches(pattern: "[-]+(?:BEGIN|END)\\s+[A-Z]*\\s*(?:PRIVATE|PUBLIC) KEY[-]+")
            .removingRegexMatches(pattern: "\\s+")
            .replacingOccurrences(of: "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A", with: "")
        return newKey
    }
    
    func removingRegexMatches(pattern: String, replaceWith: String = "") -> String {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let range = NSRange(location: 0, length: count)
            let str = regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: replaceWith)
            return str
        } catch { return self }
    }
}


