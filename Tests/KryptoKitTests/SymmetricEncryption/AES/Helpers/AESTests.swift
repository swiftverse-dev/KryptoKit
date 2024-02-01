//
//  AESTests.swift
//  
//
//  Created by Lorenzo Limoli on 01/02/24.
//

import XCTest
import KryptoKit

class AESTests: XCTestCase {

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
