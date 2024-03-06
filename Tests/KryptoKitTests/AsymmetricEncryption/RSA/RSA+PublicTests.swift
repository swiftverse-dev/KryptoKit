//
//  RSA+PublicTests.swift
//  
//
//  Created by Lorenzo Limoli on 06/03/24.
//

import XCTest
import KryptoKit

final class RSA_PublicTests: RSATests {
    typealias SUT = RSA.Public
    
    func test_initFromData_succeedsOnValidData() {
        let pubKey = publicKeyX509.dataAsBase64
        expect(error: nil, ofType: RSA.Error.self) {
            try SUT(from: pubKey)
        }
    }
    
    func test_initFromString_throwsInvalidKeyFormatForInvalidKey() {
        let invalidKey = "Public Key"
        expect(error: .invalidKeyFormat, ofType: RSA.Error.self) {
            try SUT(string: invalidKey)
        }
    }
    
    func test_initFromString_succeedsOnX509Format() {
        expect(error: nil, ofType: RSA.Error.self) {
            try SUT(string: publicKeyX509)
        }
    }
    
    func test_initFromString_succeedsOnAns1Format() {
        expect(error: nil, ofType: RSA.Error.self) {
            try SUT(string: publicAns1)
        }
    }
    
    func test_initFromString_succeedsOnPemFormat() {
        expect(error: nil, ofType: RSA.Error.self) {
            try SUT(string: publicPem)
        }
    }
    
    func test_encrypt_succeedsProducingCorrectCipherText() throws {
        let suite = encryptionSuite
        let sut = try SUT(string: suite.pubKey)
        let privKey = try RSA.Private(string: suite.privKey)
        print(privKey.pem!)
        
        var result: Data!
        expect(error: nil, ofType: RSA.Error.self) {
            result = try sut.encrypt(data: Data(suite.plainText.utf8))
        }
        
        let plainText = try privKey.decrypt(cipherText: result)
        XCTAssertEqual(plainText, suite.plainText.data(using: .utf8))
    }
    
    func test_verify_succeedsOnCorrectSignature() throws {
        let suite = signatureSuite
        let sut = try SUT(string: suite.pubKey)
        let document = Data(suite.document.utf8)
        
        expect(error: nil, ofType: RSA.Error.self) {
            try sut.verify(signature: suite.signature.dataAsBase64, for: document)
        }
    }
    
    func test_verify_throwsInvalidSignatureOnWrongPubKey() throws {
        let suite = signatureSuite
        let sut = try SUT(string: publicPem)
        let document = Data(suite.signature.utf8)
        
        expect(error: RSA.Error.invalidSignature, ofType: RSA.Error.self) {
            try sut.verify(signature: suite.signature.dataAsBase64, for: document)
        }
    }
}

private extension String {
    var dataAsBase64: Data {
        Data(base64Encoded: self)!
    }
}
