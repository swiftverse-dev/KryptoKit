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
}

private extension AES_ECBTests {
    func makeSUT(key: AES.Key = .k128(), padding: SUT.Padding = .pkcs7) -> SUT {
        return SUT(key: key, padding: padding)
    }
}
