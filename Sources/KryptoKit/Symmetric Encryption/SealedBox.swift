//
//  SealedBox.swift
//
//
//  Created by Lorenzo Limoli on 01/02/24.
//

import Foundation

public protocol SealedBox<Algorithm> {
    associatedtype Algorithm: SymmetricAlgorithm
    
    func `open`(using key: any SymmetricKey<Algorithm>) throws -> Data
    var cipherText: Data { get }
}
