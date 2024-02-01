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
        self._algo = algo
        self._mode = mode
        self._iv = iv
        self._padding = padding
    }
    
    private let _algo: CCAlgorithm
    private let _mode: CCMode
    private let _iv: Data?
    private let _padding: CCPadding
    
    func encrypt(plainData: Data, using key: Data) throws -> Data {
        try _applyOperation(data: plainData, operation: CCOperation(kCCEncrypt), key: key)
    }
    
    func decrypt(encryptedData: Data, using key: Data) throws -> Data {
        try _applyOperation(data: encryptedData, operation: CCOperation(kCCDecrypt), key: key)
    }
    
    func _applyOperation(data: Data, operation: CCOperation, key: Data) throws -> Data{
        
        let key = key as NSData
        let data = data as NSData
        let iv = (_iv ?? Data.init(bytes: [Int8](repeating: 0, count: key.count), count: key.count)) as NSData
        
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
            _mode,
            _algo,
            _padding,
            iv.bytes,
            key.bytes,
            key.length,
            nil,
            0,
            0,
            CCModeOptions(kCCOptionPKCS7Padding), // useless by doc
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
