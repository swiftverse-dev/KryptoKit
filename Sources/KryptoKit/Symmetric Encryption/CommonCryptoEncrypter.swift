//
//  File.swift
//  
//
//  Created by Lorenzo Limoli on 01/02/24.
//

import Foundation
import CommonCrypto

final class CommonCryptoEncrypter {
    
    struct StatusError: Error{
        let code: Int
    }
    
    init(
        algo: CCAlgorithm,
        mode: CCMode,
        iv: Data? = nil,
        padding: CCPadding = CCPadding(ccPKCS7Padding)
    ) {
        self.algo = algo
        self.mode = mode
        self.iv = iv
        self.padding = padding
    }
    
    private let algo: CCAlgorithm
    private let mode: CCMode
    private let iv: Data?
    private let padding: CCPadding
    
    func encrypt(plainData: Data, using key: Data) throws -> Data {
        try applyOperation(data: plainData, operation: CCOperation(kCCEncrypt), key: key)
    }
    
    func decrypt(encryptedData: Data, using key: Data) throws -> Data {
        try applyOperation(data: encryptedData, operation: CCOperation(kCCDecrypt), key: key)
    }
    
    private func applyOperation(data: Data, operation: CCOperation, key: Data) throws -> Data{
        
        let key = key as NSData
        let data = data as NSData
        let iv = (iv ?? Data.init(bytes: [Int8](repeating: 0, count: key.count), count: key.count)) as NSData
        
        var dataOutMoved: size_t = 0
        var dataOutMovedTotal: size_t = 0
        var status: CCCryptorStatus = 0
        var cryptor: CCCryptorRef? = nil
        
        defer{
            if cryptor != nil{
                CCCryptorRelease(cryptor)
            }
        }
        
        status = CCCryptorCreateWithMode(
            operation,
            mode,
            algo,
            padding,
            iv.bytes,
            key.bytes,
            key.length,
            nil, // not used
            0,   // not used
            0,   // not used
            0,   // not used
            &cryptor
        )
        
        if(cryptor == nil || status != kCCSuccess){
            throw StatusError(code: Int(status))
        }
        
        let dataOutLen = CCCryptorGetOutputLength(cryptor, data.length, true)
        let dataOut = NSMutableData(length: dataOutLen)!
        
        status = CCCryptorUpdate(
            cryptor,
            data.bytes,
            data.length,
            dataOut.mutableBytes,
            dataOut.length,
            &dataOutMoved
        )
        
        dataOutMovedTotal += dataOutMoved
        
        if(status != kCCSuccess){
            throw StatusError(code: Int(status))
        }
        
        status = CCCryptorFinal(
            cryptor,
            dataOut.mutableBytes + dataOutMoved,
            dataOutLen - dataOutMoved,
            &dataOutMoved
        )
        
        if(status != kCCSuccess){
            throw StatusError(code: Int(status))
        }
        
        dataOutMovedTotal += dataOutMoved
        dataOut.length = dataOutMovedTotal
        return Data(referencing: dataOut)
    }
}
