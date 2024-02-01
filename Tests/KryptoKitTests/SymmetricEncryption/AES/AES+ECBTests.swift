//
//  AES+ECBTests.swift
//  
//
//  Created by Lorenzo Limoli on 01/02/24.
//

import XCTest
import KryptoKit

final class AES_ECBTests: XCTestCase {
    typealias SUT = AES.ECB
    
    func test_sealedBoxFromCipherText_createSealedBoxWithTheSameCipherText() throws {
        let sut = makeSUT()
        let cipherText = Data("cipherText".utf8)
        let sbox = sut.sealedBox(fromCipherText: cipherText)
        XCTAssertEqual(sbox.cipherText, cipherText)
    }
    
    func test_seal_createsSealedBoxWithCorrectCipherText() throws {
        let sut128 = makeSUT(key: k128)
        let sbox128 = try sut128.seal(plainText: plainText)
        XCTAssertEqual(sbox128.cipherText, cipherText128)
        
        let sut192 = makeSUT(key: k192)
        let sbox192 = try sut192.seal(plainText: plainText)
        XCTAssertEqual(sbox192.cipherText, cipherText192)
        
        let sut256 = makeSUT(key: k256)
        let sbox256 = try sut256.seal(plainText: plainText)
        XCTAssertEqual(sbox256.cipherText, cipherText256)
    }
}

private extension AES_ECBTests {
    var plainText: Data{
        Data("This is a secret message".utf8)
    }
    
    var cipherText128: Data {
        Data(base64Encoded: "t8vP+hOjSj3a/nK0gzk+IhT8kfF/m1wLdBCnEEXIyY8=")!
    }
    
    var cipherText192: Data {
        Data(base64Encoded: "rnvWu25YDHHUZ0PVfSIch9UhnDTWb2AE6rkCGiEZ4pU=")!
    }
    
    var cipherText256: Data {
        Data(base64Encoded: "kkHEVgnmehhIglF9AZh1wUJYviJcDMCFr+Wp3IkyHFA=")!
    }
    
    var k128: AES.Key { try! AES.Key.k128(key: "1234567890123456") }
    var k192: AES.Key { try! AES.Key.k192(key: "123456789012345612345678") }
    var k256: AES.Key { try! AES.Key.k256(key: "12345678901234561234567890123456") }
    
    func makeSUT(key: AES.Key = .k128(), padding: SUT.Padding = .pkcs7) -> SUT {
        return SUT(key: key, padding: padding)
    }
}
