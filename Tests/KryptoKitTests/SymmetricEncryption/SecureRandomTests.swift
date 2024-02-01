//
//  SecureRandomTests.swift
//  
//
//  Created by Lorenzo Limoli on 31/01/24.
//

import XCTest
import KryptoKit

final class SecureRandomTests: XCTestCase {
    typealias SUT = SecureRandom
    
    func test_generate_withBitSizeThrowBadSizeIfNotConvertibleToByte() {
        let nonConvertibleToByteSizes: [UInt] = [1, 2, 10, 11, 100, 101]
        
        nonConvertibleToByteSizes.forEach{ bitSize in
            expect(toThrow: .badSize) { try SUT.generate(bitSize: bitSize) }
        }
    }
    
    func test_generate_withBitSizeSucceedsIfConvertibleToByteAndResultHasCorrectNumberOfBytes() throws {
        let convertibleToByteSizes: [UInt] = [0, 8, 16, 192, 256]
        
        for bitSize in convertibleToByteSizes {
            let secureRandom = try SUT.generate(bitSize: bitSize)
            XCTAssertEqual(secureRandom.count, Int(bitSize) / 8)
        }
    }
    
    func test_generate_withByteSizeSucceedsAndResultHasCorrectNumberOfBytes() throws {
        for byteSize in stride(from: 0, to: 256, by: 8) {
            let secureRandom = try SUT.generate(byteSize: UInt(byteSize))
            XCTAssertEqual(secureRandom.count, byteSize)
        }
    }
}

private extension SecureRandomTests {
    func expect(toThrow expectedError: SUT.Error, during action: () throws -> Void, file: StaticString = #filePath, line: UInt = #line) {
        do{
            try action()
            XCTFail("Expected to throw \(expectedError), succeeded instead", file: file, line: line)
        } catch let error as SUT.Error {
            XCTAssertEqual(error, expectedError)
        } catch {
            XCTFail("Expected to throw \(expectedError), got \(error) instead", file: file, line: line)
        }
    }
}
