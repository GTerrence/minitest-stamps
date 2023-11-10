//
//  DisplayNumbers.swift
//  minitest-stamps
//
//  Created by Terrence Pramono on 10/11/23.
//

import Foundation

/// Struct for Program Kecil Mini Test
struct DisplayNumbers {
    
    func execute() {
        print("Displayed Numbers :")
        print()
        for i in stride(from: 100, to: 0, by: -1) {
            if i % 15 == 0 {
                print("FooBar", terminator: ", ")
            } else if i % 3 == 0 {
                print("Foo", terminator: ", ")
            } else if i % 5 == 0 {
                print("Bar", terminator: ", ")
            } else if !isPrime(i) {
                print(i, terminator: ", ")
            }
        }
    }
    
    
    /// To check if number is prime numbers
    /// - Parameter n: integer that need to be checked
    /// - Returns: Bool
    func isPrime(_ n: Int) -> Bool {
        if n < 2 {
            return false
        }
        if n == 2 {
            return true
        }
        if n % 2 == 0 {
            return false
        }
        return !stride(from: 7, to: Int(sqrt(Double(n))), by: 2).contains(where: { n % $0 == 0 })
    }
}
