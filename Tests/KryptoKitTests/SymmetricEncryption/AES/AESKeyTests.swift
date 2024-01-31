//
//  AESKeyTests.swift
//  
//
//  Created by Lorenzo Limoli on 31/01/24.
//

import XCTest
@testable import KryptoKit

final class AESKeyTests: XCTestCase {
    typealias SUT = AES.Key
    
    func test_k128_generateRandomKeyWithSizeOf128Bit() {
        let keys = (0..<10).map{ _ in SUT.k128() }
        keys.forEach{
            XCTAssertEqual($0.size, SUT.aes128)
        }
        XCTAssertEqual(Set(keys).count, keys.count)
    }
    
    func test_k192_generateRandomKeyWithSizeOf192Bit() {
        let keys = (0..<10).map{ _ in SUT.k192() }
        keys.forEach{
            XCTAssertEqual($0.size, SUT.aes192)
        }
        XCTAssertEqual(Set(keys).count, keys.count)
    }
    
    func test_k256_generateRandomKeyWithSizeOf256Bit() {
        let keys = (0..<10).map{ _ in SUT.k256() }
        keys.forEach{
            XCTAssertEqual($0.size, SUT.aes256)
        }
        XCTAssertEqual(Set(keys).count, keys.count)
    }
    
    func test_k128_generateDerivedKeyFromPassowordWithSizeOf128Bit() {
        let password = "A Password"
        let salt = Data("12345678".utf8)
        XCTAssert(salt.count == 8)
        
        let keys = (0..<10).map{ _ in SUT.k128(derivedFrom: password, salt: salt) }
        keys.forEach{
            dump($0)
            XCTAssertEqual($0.size, SUT.aes128)
        }
        XCTAssertEqual(Set(keys).count, 1)
    }
    
    func test_k192_generateDerivedKeyFromPassowordWithSizeOf192Bit() {
        let password = "A Password"
        let salt = Data("12345678".utf8)
        XCTAssert(salt.count == 8)
        
        let keys = (0..<10).map{ _ in SUT.k128(derivedFrom: password, salt: salt) }
        keys.forEach{
            dump($0)
            XCTAssertEqual($0.size, SUT.aes128)
        }
        XCTAssertEqual(Set(keys).count, 1)
    }
    
    func test_k256_generateDerivedKeyFromPassowordWithSizeOf256Bit() {
        let password = "A Password"
        let salt = Data("12345678".utf8)
        XCTAssert(salt.count == 8)
        
        let keys = (0..<10).map{ _ in SUT.k128(derivedFrom: password, salt: salt) }
        keys.forEach{
            dump($0)
            XCTAssertEqual($0.size, SUT.aes128)
        }
        XCTAssertEqual(Set(keys).count, 1)
    }

}
