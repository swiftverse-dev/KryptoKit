//
//  SymmetricAlgorithm.swift
//  
//
//  Created by Lorenzo Limoli on 01/02/24.
//

import Foundation

public protocol SymmetricAlgorithm {}

public protocol SymmetricEncrypter<Key> {
    associatedtype Key: SymmetricKey
    associatedtype SBox: SealedBox<Key>
    
    func seal(plainText: Data, using key: Key) throws -> SBox
    func sealedBox(fromCipherText cipherText: Data) -> SBox
}
