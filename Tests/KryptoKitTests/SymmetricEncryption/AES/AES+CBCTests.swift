//
//  AES+CBCTests.swift
//  
//
//  Created by Lorenzo Limoli on 01/02/24.
//

import XCTest
import KryptoKit

final class AES_CBCTests: AESTests {
    typealias SUT = AES.CBC

    override var cipherText128: Data {
        Data(base64Encoded: "muJNZwhxg173v6EZAXb5TK8L5XlmDE5xmc9XTryH6Qk=")!
    }
    
    override var cipherText192: Data {
        Data(base64Encoded: "I+Whvz0Zw4YsPzsUDcjCsoLTzoUyfgOaBSu50eV8aps=")!
    }
    
    override var cipherText256: Data {
        Data(base64Encoded: "GNUPH5ksym86ty6gofTWhpi3RFAGovmapfiGRXpxcYE=")!
    }
    
    func test_init_throwsBadIvSizeForIVNotMatchingAESblockSize() {
        let smallerIV = Data("1234567890".utf8)
        let biggerIV = Data("12345678901234567890".utf8)
        
        expect(toThrow: .badParameterSize) {
            _ = try SUT(iv: smallerIV)
        }
        
        expect(toThrow: .badParameterSize) {
            _ = try SUT(iv: biggerIV)
        }
    }
    
    func test_init_initializesSuccessfullySUTForIvWith128BitSize() throws {
        let correctIV = iv.data
        XCTAssertNoThrow(try SUT(iv: correctIV))
    }
    
    func test_sealedBoxFromCipherText_createSealedBoxWithTheSameCipherText() throws {
        let sut = makeSUT()
        try assert_sealedBoxFromCipherText_createSealedBoxWithTheSameCipherText(sut: sut)
    }
    
    func test_seal_createsSealedBoxWithCorrectCipherText() throws {
        let sut = makeSUT()
        try assert_seal_createsSealedBoxWithCorrectCipherText(sut: sut)
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

private extension AES_CBCTests {
    var iv: SUT.IV { try! SUT.IV(data: Data("1234567890123456".utf8)) }
    func makeSUT(iv: SUT.IV? = nil) -> SUT { SUT(iv: iv ?? self.iv) }
}
