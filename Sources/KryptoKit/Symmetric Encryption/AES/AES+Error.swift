//
//  AES+Error.swift
//
//
//  Created by Lorenzo Limoli on 01/02/24.
//

import Foundation
import CryptoKit

public extension AES {
    enum Error: Swift.Error, Equatable {
        case badKeySize
        case badParameterSize
        case authenticationFailure
        case alignmentError
        case statusError(code: Int)
        case error(message: String)
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
    
    static func cryptoKit(error: Error) -> Self {
        guard let ckError = error as? CryptoKitError else {
            return Self.error(message: error.localizedDescription)
        }
        
        return switch ckError {
        case .incorrectKeySize: Self.badKeySize
        case .incorrectParameterSize: Self.badParameterSize
        case .authenticationFailure: Self.authenticationFailure
        case .underlyingCoreCryptoError(let error): Self.statusError(code: Int(error))
        default: Self.error(message: error.localizedDescription)
        }
        
    }
}

