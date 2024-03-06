//
//  PrivateKey.swift
//
//
//  Created by Lorenzo Limoli on 06/03/24.
//

import Foundation


public protocol PrivateKey<Algorithm>: AsymmetricKey {
    associatedtype Algorithm: AsymmetricAlgorithm
    associatedtype PubKey: PublicKey<Algorithm>
    
    func publicKey() throws -> PubKey
    func decrypt(cipherText: Data) throws -> Data
    func sign(_ document: Data) throws -> Data
}

public extension PrivateKey {
    func opaquePublicKey() throws -> any PublicKey<Algorithm> {
        try publicKey() as any PublicKey<Algorithm>
    }
}
