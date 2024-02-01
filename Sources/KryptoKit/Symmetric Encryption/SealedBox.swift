//
//  SealedBox.swift
//
//
//  Created by Lorenzo Limoli on 01/02/24.
//

import Foundation

public protocol SealedBox<Key> {
    associatedtype Key: SymmetricKey
    
    func `open`(using key: Key) throws -> Data
    var cipherText: Data { get }
}
