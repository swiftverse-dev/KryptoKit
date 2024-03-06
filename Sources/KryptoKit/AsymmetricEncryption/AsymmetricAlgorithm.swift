//
//  AsymmetricAlgorithm.swift
//
//
//  Created by Lorenzo Limoli on 06/03/24.
//

import Foundation

public protocol AsymmetricAlgorithm {
    static var encryptionAlgorithm: SecKeyAlgorithm { get }
    static var signatureAlgorithm: SecKeyAlgorithm { get }
}
