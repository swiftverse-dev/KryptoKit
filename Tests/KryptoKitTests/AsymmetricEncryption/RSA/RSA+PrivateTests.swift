//
//  RSA+PrivateTests.swift
//  
//
//  Created by Lorenzo Limoli on 06/03/24.
//

import XCTest
import KryptoKit
import StorageKit

final class RSA_PrivateTests: RSATests {
    typealias SUT = RSA.Private
    
    private lazy var keystore = Keystore(storeId: "test.rsa.keystore", protection: .whenUnlocked)

    func test_initFromBitSize_throwsErrorOnInvalidSize() {
        XCTAssertThrowsError(try makeSUT(bitSize: invalidSize))
    }
    
    func test_initFromBitSize_succeedsOnValidBitSize() {
        XCTAssertNoThrow(try makeSUT(bitSize: validSize))
    }
    
    func test_initFromData_throwsErrorOnPkcs8KeyData() {
        expect(error: .parsingError, ofType: Keystore.Error.self) {
            try makeSUT(from: privatePkcs8Base64.dataAsBase64)
        }
    }
    
    func test_initFromData_succeedsOnPkcs1KeyData() throws {
        XCTAssertNoThrow(try makeSUT(from: privatePkcs1Base64.dataAsBase64))
    }
    
    func test_initFromString_throwsInvalidKeyFormatOnInvalidKeyFormat() {
        let invalidKey = "Private Key"
        expect(error: .invalidKeyFormat, ofType: RSA.Error.self) {
            try makeSUT(string: invalidKey)
        }
    }
    
    func test_initFromString_succeedsOnPkcs1KeyString() {
        expect(error: nil, ofType: RSA.Error.self) {
            try makeSUT(string: privatePkcs1Base64)
        }
    }
    
    func test_initFromString_succeedsOnPemKeyString() {
        expect(error: nil, ofType: RSA.Error.self) {
            try makeSUT(string: privateKeyPem)
        }
    }
    
    func test_getPublicKey_extractSuccessfullyTheCorrespondingKey() throws {
        let sut = try makeSUT(from: privatePkcs1Base64.dataAsBase64)
        let pubKey = try sut.publicKey()
        XCTAssertEqual(pubKey.data, publicKeyX509.dataAsBase64)
    }
    
    func test_decryptCipherText_succeedsWhenUsingCorrectCipherText() throws {
        let suite = encryptionSuite
        let sut = try makeSUT(string: suite.privKey)
        
        var result: Data!
        expect(error: nil, ofType: RSA.Error.self) {
            result = try sut.decrypt(cipherText: suite.cipherText.dataAsBase64)
        }
        
        XCTAssertEqual(result, suite.plainText.data(using: .utf8))
    }
    
    func test_decryptCipherText_throwsDecryptionErrorForInvalidCipherText() throws {
        let sut = try makeSUT(string: encryptionSuite.privKey)
        let invalidCipherText = Data("Invalid Cipher Text".utf8)

        expect(error: .decryptionError, ofType: RSA.Error.self) {
            try sut.decrypt(cipherText: invalidCipherText)
        }
    }
    
    func test_sign_succeedsProducingCorrectSignature() throws {
        let suite = signatureSuite
        let sut = try makeSUT(string: suite.privKey)
        let document = Data(suite.document.utf8)
        
        var result: Data!
        expect(error: nil, ofType: RSA.Error.self) {
            result = try sut.sign(document)
        }
        
        XCTAssertEqual(result, suite.signature.dataAsBase64)
    }
}

// Need an host app
extension RSA_PrivateTests {
    
//    func test_initFromStore_throwsItemNotFoundForUknownTag() {
//        let unknownTag = "UknownTag"
//        expect(error: .keychainError(.itemNotFound), ofType: Keystore.Error.self) {
//            try makeSUT(loadingFrom: unknownTag)
//        }
//    }
  
//    func test_initFromStore_loadTheCorrectKeyPreviouslyStored() throws {
//        let sut1 = try makeSUT(tag: knownTag)
//        var sut2: SUT!
//
//        expect(error: nil, ofType: Keystore.Error.self) {
//            sut2 = try makeSUT(loadingFrom: knownTag)
//        }
//
//        XCTAssertEqual(sut1.data, sut2.data)
//    }
    
//    func test_initFromData_storesSuccessfullyKeyFromPkcs1Data() throws {
//        let sut = try makeSUT(from: privatePkcs1Base64.dataAsBase64, tag: knownTag)
//        let loadedKey = try keystore.loadKey(for: knownTag)
//        XCTAssertEqual(sut.data, loadedKey.data)
//    }
    
//    func test_initFromBitSize_succeedsAndActuallyStoresKeyOnKeystore() throws {
//        let sut = try makeSUT(tag: knownTag)
//        let loadedKey = try keystore.loadKey(for: knownTag)
//        XCTAssertEqual(loadedKey.data, sut.data)
//    }
}

private extension RSA_PrivateTests {
    var validSize: Int { 1024 }
    var invalidSize: Int { 1 }
    var knownTag: String { "knownTag" }
    
    func makeSUT(bitSize: Int? = nil, tag: String? = nil) throws -> SUT {
        let store = tag.map{ (keystore, tag: $0) } ?? nil
        let sut = try SUT(bitSize: bitSize ?? validSize, storingTo: store)
        removeKeyOnTearDown(tag: tag)
        return sut
    }
    
    func makeSUT(from data: Data, tag: String? = nil) throws -> SUT {
        let store = tag.map{ (keystore, tag: $0) } ?? nil
        let sut = try SUT(from: data, storingTo: store)
        removeKeyOnTearDown(tag: tag)
        return sut
    }
    
    func makeSUT(string: String, tag: String? = nil) throws -> SUT {
        let store = tag.map{ (keystore, tag: $0) } ?? nil
        let sut = try SUT(string: string, storingTo: store)
        removeKeyOnTearDown(tag: tag)
        return sut
    }
    
    func makeSUT(loadingFrom tag: String) throws -> SUT {
        let sut = try SUT(loadingFrom: keystore, tag: tag)
        removeKeyOnTearDown(tag: tag)
        return sut
    }
    
    private func removeKeyOnTearDown(tag: String?) {
        guard let tag else { return }
        addTeardownBlock { [weak keystore] in
            keystore?.deleteKey(for: tag)
        }
    }
}


private extension String {
    var dataAsBase64: Data {
        Data(base64Encoded: self)!
    }
}
