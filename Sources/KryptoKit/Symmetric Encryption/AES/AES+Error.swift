//
//  AES+Error.swift
//
//
//  Created by Lorenzo Limoli on 01/02/24.
//

import Foundation

public extension AES {
    enum Error: Swift.Error, Equatable {
        case badKeySize
        case statusError(code: Int)
    }
}
