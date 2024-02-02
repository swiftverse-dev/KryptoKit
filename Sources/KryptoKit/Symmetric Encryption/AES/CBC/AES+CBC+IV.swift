//
//  AES+CBC+IV.swift
//
//
//  Created by Lorenzo Limoli on 01/02/24.
//

import Foundation

public extension AES.CBC {
    struct IV {
        public let data: Data
        
        public init(data: Data) throws {
            let blockSize = data.count
            if blockSize != AES.blockSize {
                throw AES.Error.badParameterSize
            }
            self.data = data
        }
        
        public init() {
            self.data = try! SecureRandom.generate(byteSize: UInt(AES.blockSize))
        }
    }
}
