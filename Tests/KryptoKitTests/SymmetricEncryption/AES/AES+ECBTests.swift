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

    override var cipherText128: Data {
        Data(base64Encoded: "t8vP+hOjSj3a/nK0gzk+IhT8kfF/m1wLdBCnEEXIyY8=")!
    }
    
    override var cipherText192: Data {
        Data(base64Encoded: "rnvWu25YDHHUZ0PVfSIch9UhnDTWb2AE6rkCGiEZ4pU=")!
    }
    
    override var cipherText256: Data {
        Data(base64Encoded: "kkHEVgnmehhIglF9AZh1wUJYviJcDMCFr+Wp3IkyHFA=")!
    }
    
    
    func test_sealedBoxFromCipherText_createSealedBoxWithTheSameCipherText() throws {
        let sut = makeSUT()
        try assert_sealedBoxFromCipherText_createSealedBoxWithTheSameCipherText(sut: sut)
    }
    
    func test_seal_createsSealedBoxWithCorrectCipherText() throws {
        let sut = makeSUT()
        try assert_seal_createsSealedBoxWithCorrectCipherText(sut: sut)
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
    
    func test_openSealedBox_extractsTheCorrectPlainText() throws {
        let sut = makeSUT()
        try assert_openSealedBox_extractsTheCorrectPlainText(sut: sut)
    }
    
    func test_openSealedBox_returnsTheSamePlainTextUsedToCreateTheBox() throws {
        let sut = makeSUT()
        try assert_openSealedBox_returnsTheSamePlainTextUsedToCreateTheBox(sut: sut)
    }
}

private extension AES_ECBTests {
    func makeSUT(padding: SUT.Padding = .pkcs7) -> SUT {
        return SUT(padding: padding)
    }
}
