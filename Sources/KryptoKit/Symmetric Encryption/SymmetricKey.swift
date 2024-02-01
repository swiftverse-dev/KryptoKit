//
//  SymmetricKey.swift
//
//
//  Created by Lorenzo Limoli on 01/02/24.
//

import Foundation

public protocol SymmetricKey<Algorithm>: ContiguousBytes {
    associatedtype Algorithm: SymmetricAlgorithm
    var data: Data { get }
}
