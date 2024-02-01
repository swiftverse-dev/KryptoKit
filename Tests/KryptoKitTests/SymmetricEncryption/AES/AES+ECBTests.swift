//
//  AES+ECBTests.swift
//  
//
//  Created by Lorenzo Limoli on 01/02/24.
//

import XCTest
import KryptoKit

final class AES_ECBTests: AESTests {
    typealias SUT = AES.ECB
    
    func test_sealedBoxFromCipherText_createSealedBoxWithTheSameCipherText() throws {
        let sut = makeSUT()
        let cipherText = Data("cipherText".utf8)
        let sbox = sut.sealedBox(fromCipherText: cipherText)
        XCTAssertEqual(sbox.cipherText, cipherText)
    }
    
    func test_seal_createsSealedBoxWithCorrectCipherText() throws {
        let sut = makeSUT()
        
        let sbox128 = try sut.seal(plainText: plainText, using: k128)
        XCTAssertEqual(sbox128.cipherText, cipherText128)
        
        let sbox192 = try sut.seal(plainText: plainText, using: k192)
        XCTAssertEqual(sbox192.cipherText, cipherText192)
        
        let sbox256 = try sut.seal(plainText: plainText, using: k256)
        XCTAssertEqual(sbox256.cipherText, cipherText256)
    }
    
    func test_openSealedBox_extractsTheCorrectPlainText() throws {
        let sut = makeSUT()
        
        let sbox128 = sut.sealedBox(fromCipherText: cipherText128)
        try XCTAssertEqual(sbox128.open(using: k128), plainText)
        
        let sbox92 = sut.sealedBox(fromCipherText: cipherText192)
        try XCTAssertEqual(sbox92.open(using: k192), plainText)
        
        let sbox256 = sut.sealedBox(fromCipherText: cipherText256)
        try XCTAssertEqual(sbox256.open(using: k256), plainText)
    }
    
    func test_seal_throwsAlignmentErrorWhenNoPaddingAndIfPlainTextIsNotMultipleOfBlockSize() {
        let plainTextNotMultipleOf128 = plainText
        
        let sut = makeSUT(padding: .none)
        
        expect(toThrow: .alignmentError) {
            _ = try sut.seal(plainText: plainTextNotMultipleOf128, using: k128)
        }
        
        expect(toThrow: .alignmentError) {
            _ = try sut.seal(plainText: plainTextNotMultipleOf128, using: k192)
        }
        
        expect(toThrow: .alignmentError) {
            _ = try sut.seal(plainText: plainTextNotMultipleOf128, using: k256)
        }
    }
    
    func test_seal_createsSealedBoxSuccessfullyWhenPaddingNoneAndPlainTextIsMultipleOf128() {
        let plainTextMultipleOf128 = Data("1234567890123456".utf8)
        
        let sut = makeSUT(padding: .none)
        XCTAssertNoThrow(try sut.seal(plainText: plainTextMultipleOf128, using: k128))
        XCTAssertNoThrow(try sut.seal(plainText: plainTextMultipleOf128, using: k192))
        XCTAssertNoThrow(try sut.seal(plainText: plainTextMultipleOf128, using: k256))
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
    
    func makeSUT(padding: SUT.Padding = .pkcs7) -> SUT {
        return SUT(padding: padding)
    }
}
