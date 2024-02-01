//
//  AESKeyTests.swift
//  
//
//  Created by Lorenzo Limoli on 31/01/24.
//

import XCTest
@testable import KryptoKit

final class AESKeyTests: AESTests {
    typealias SUT = AES.Key
    
    func test_k128_k192_k256_throwsBadKeySizeErrorIfKeyDoNotMatchLen() throws {
        let wrongKeys = try [8, 16, 64, 512, 80, 1024].map(SecureRandom.generate(bitSize:))
        for wrongKey in wrongKeys {
            expect(toThrow: .badKeySize) {
                _ = try SUT.k128(key: wrongKey)
            }
            
            expect(toThrow: .badKeySize) {
                _ = try SUT.k192(key: wrongKey)
            }
            
            expect(toThrow: .badKeySize) {
                _ = try SUT.k256(key: wrongKey)
            }
        }
    }
    
    func test_k128_k192_k256_createSuccessfullyTheCorrespondingKey() throws {
        let k128 = try SecureRandom.generate(bitSize: 128)
        try XCTAssertEqual(SUT.k128(key: k128).data, k128)
        
        let k192 = try SecureRandom.generate(bitSize: 192)
        try XCTAssertEqual(SUT.k192(key: k192).data, k192)
        
        let k256 = try SecureRandom.generate(bitSize: 256)
        try XCTAssertEqual(SUT.k256(key: k256).data, k256)
    }
    
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

