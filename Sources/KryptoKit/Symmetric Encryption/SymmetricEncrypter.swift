//
//  SymmetricEncrypter.swift
//  
//
//  Created by Lorenzo Limoli on 06/03/24.
//

import Foundation

public protocol SymmetricEncrypter<Algorithm> {
    associatedtype Algorithm: SymmetricAlgorithm
    associatedtype SBox: SealedBox<Algorithm>
    
    func seal(plainText: Data, using key: any SymmetricKey<Algorithm>) throws -> SBox
    func sealedBox(fromCipherText cipherText: Data) -> SBox
}

public extension SymmetricEncrypter {
    func opaqueSeal(plainText: Data, using key: any SymmetricKey<Algorithm>) throws -> any SealedBox<Algorithm> {
        try seal(plainText: plainText, using: key)
    }
    
    func opaqueSealedBox(fromCipherText cipherText: Data) -> any SealedBox<Algorithm> {
        sealedBox(fromCipherText: cipherText)
    }
}
