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
    
    func seal(plainText: Data) throws -> any SealedBox<Key>
    func sealedBox(fromCipherText cipherText: Data) -> any SealedBox<Key>
}
