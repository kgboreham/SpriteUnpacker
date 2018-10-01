//
//  Output.swift
//  SpriteUnpacker
//
//  Created by Ken Boreham on 12/2/17.
//  Copyright © 2017 Ken Boreham. All rights reserved.
//

import Foundation

protocol Output {
    func write(_ message: String)
    func error(_ message: String)
}

class ConsoleOutput: Output {
    func write(_ message: String) {
        print("\u{001B}[;m\(message)")
    }
    func error(_ message: String) {
        fputs("\u{001B}[0;31m\(message)\n", stderr)
    }
}
