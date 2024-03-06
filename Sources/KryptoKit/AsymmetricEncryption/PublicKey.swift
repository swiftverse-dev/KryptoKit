//
//  PublicKey.swift
//  
//
//  Created by Lorenzo Limoli on 06/03/24.
//

import Foundation

public protocol PublicKey<Algorithm>: AsymmetricKey {
    associatedtype Algorithm: AsymmetricAlgorithm
    
    func encrypt(data: Data) throws -> Data
    func verify(signature: Data, for document: Data) throws
}
