//
//  AESTests.swift
//  
//
//  Created by Lorenzo Limoli on 01/02/24.
//

import XCTest
import KryptoKit

 class AESTests: XCTestCase {

     func assert_sealedBoxFromCipherText_createSealedBoxWithTheSameCipherText(
        sut: any SymmetricEncrypter<AES>,
        file: StaticString = #filePath,
        line: UInt = #line
     ) throws {
         let cipherText = Data("cipherText".utf8)
         let sbox = sut.opaqueSealedBox(fromCipherText: cipherText)
         XCTAssertEqual(sbox.cipherText, cipherText, file: file, line: line)
     }
     
     func assert_seal_createsSealedBoxWithCorrectCipherText(
        sut: any SymmetricEncrypter<AES>,
        file: StaticString = #filePath,
        line: UInt = #line
     ) throws {
         let sbox128 = try sut.opaqueSeal(plainText: plainText, using: k128)
         XCTAssertEqual(sbox128.cipherText, cipherText128, file: file, line: line)
         
         let sbox192 = try sut.opaqueSeal(plainText: plainText, using: k192)
         XCTAssertEqual(sbox192.cipherText, cipherText192, file: file, line: line)
         
         let sbox256 = try sut.opaqueSeal(plainText: plainText, using: k256)
         XCTAssertEqual(sbox256.cipherText, cipherText256, file: file, line: line)
     }
     
     func assert_openSealedBox_extractsTheCorrectPlainText(
        sut: any SymmetricEncrypter<AES>,
        file: StaticString = #filePath,
        line: UInt = #line
     ) throws {
         let sbox128 = sut.opaqueSealedBox(fromCipherText: cipherText128)
         try XCTAssertEqual(sbox128.open(using: k128), plainText, file: file, line: line)
         
         let sbox92 = sut.opaqueSealedBox(fromCipherText: cipherText192)
         try XCTAssertEqual(sbox92.open(using: k192), plainText, file: file, line: line)
         
         let sbox256 = sut.opaqueSealedBox(fromCipherText: cipherText256)
         try XCTAssertEqual(sbox256.open(using: k256), plainText, file: file, line: line)
     }
     
     func assert_openSealedBox_returnsTheSamePlainTextUsedToCreateTheBox(
        sut: any SymmetricEncrypter<AES>,
        file: StaticString = #filePath,
        line: UInt = #line
     ) throws {
         let sbox128 = try sut.opaqueSeal(plainText: plainText, using: k128)
         try XCTAssertEqual(sbox128.open(using: k128), plainText, file: file, line: line)
         
         let sbox192 = try sut.opaqueSeal(plainText: plainText, using: k192)
         try XCTAssertEqual(sbox192.open(using: k192), plainText, file: file, line: line)
         
         let sbox256 = try sut.opaqueSeal(plainText: plainText, using: k256)
         try XCTAssertEqual(sbox256.open(using: k256), plainText, file: file, line: line)
     }
}

extension AESTests {
    var plainText: Data{
        Data("This is a secret message".utf8)
    }
    
    var cipherText128: Data { Data() }
    
    var cipherText192: Data { Data() }
    
    var cipherText256: Data { Data() }
    
    var k128: AES.Key { try! AES.Key.k128(key: "1234567890123456") }
    var k192: AES.Key { try! AES.Key.k192(key: "123456789012345612345678") }
    var k256: AES.Key { try! AES.Key.k256(key: "12345678901234561234567890123456") }
    
    func expect(toThrow expectedError: AES.Error, during action: () throws -> Void, file: StaticString = #filePath, line: UInt = #line) {
        do{
            try action()
            XCTFail("Expected to throw \(expectedError), succeeded instead", file: file, line: line)
        } catch let error as AES.Error {
            XCTAssertEqual(error, expectedError)
        } catch {
            XCTFail("Expected to throw \(expectedError), got \(error) instead", file: file, line: line)
        }
    }
}
