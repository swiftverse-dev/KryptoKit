//
//  CatchMapOperator.swift
//
//
//  Created by Lorenzo Limoli on 01/02/24.
//

import Foundation

infix operator ~>

func ~> <Value>(expr: @autoclosure () throws -> Value, mapError: (Error) -> Error) throws -> Value {
    do { return try expr() }
    catch { throw mapError(error) }
}
