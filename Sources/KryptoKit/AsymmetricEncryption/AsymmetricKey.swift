//
//  File.swift
//  
//
//  Created by Lorenzo Limoli on 06/03/24.
//

import Foundation
import StorageKit

public protocol AsymmetricKey {
    var secKey: SecKey { get }
}

public extension AsymmetricKey {
    var data: Data? { secKey.data }
    var stringBase64: String? { secKey.stringBase64 }
    var dataBase64: Data? { secKey.dataBase64 }
}
