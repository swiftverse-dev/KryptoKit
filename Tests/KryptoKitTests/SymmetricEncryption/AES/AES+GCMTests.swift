//
//  AES+GCMTests.swift
//  
//
//  Created by Lorenzo Limoli on 02/02/24.
//

import XCTest
import KryptoKit

final class AES_GCMTests: AESTests {
    typealias SUT = AES.GCM

    override var cipherText128: Data {
        Data(base64Encoded: "5RkH2/j4JyjG0WjQNUM/MNYTHXcMosvtGdvM4iSTH9fOgpAprh2hbw==")!
    }
    
    override var cipherText192: Data {
        Data(base64Encoded: "1qY960DBvF2Wz6+fqwc6AZuW8eDLmzN2o9f1kb8S7O8AZUJTRA5c7Q==")!
    }
    
    override var cipherText256: Data {
        Data(base64Encoded: "OVLQ89+R5zF8c6SRQPSQfJCJQUgm+hcAkqLhFZKFT+Dgng5gSZKZ/w==")!
    }
    
    func test_init_throwsBadParameterSizeErrorForWrongNonceSize() {
        let wrongNonces = ["123", "12345678901"].map{ Data($0.utf8) }
        wrongNonces.forEach{ wrongNonce in
            expect(toThrow: .badParameterSize) {
                _ = try SUT(nonce: wrongNonce)
            }
        }
    }
    
    func test_init_successfullyInitSUTForCorrectNonceSizes() throws {
        let correctNonces = ["123456789012", "1234567890123", "123456789012346", "1234567890123467890"].map{ Data($0.utf8) }
        try correctNonces.forEach{ correctNonce in
            XCTAssertNoThrow(try SUT(nonce: correctNonce))
        }
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


private extension AES_GCMTests {
    var nonce: SUT.Nonce { try! .init(data: Data("123456789012".utf8)) }
    func makeSUT(nonce: SUT.Nonce? = nil) -> SUT { SUT(nonce: nonce ?? self.nonce )}
}
