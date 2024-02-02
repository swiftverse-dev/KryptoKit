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
        case badIvSize
        case alignmentError
        case statusError(code: Int)
    }
}

extension AES.Error {
    static func statusError(_ error: Error) -> Self {
        if let statusErr = error as? CommonCryptoEncrypter.StatusError {
            statusErr.code == -4303 ? Self.alignmentError : Self.statusError(code: statusErr.code)
        }else {
            Self.statusError(code: -1)
        }
    }
}
