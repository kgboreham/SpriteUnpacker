//
//  main.swift
//  SpriteUnpacker
//
//  Created by Ken Boreham on 12/1/17.
//  Copyright © 2017 Ken Boreham. All rights reserved.
//

import Foundation

func printUsage(executableName: String, output: Output = ConsoleOutput()) {
    output.write("usage:")
    output.write("\(executableName) info_file_name")
}

guard CommandLine.argc == 2 else {
    printUsage(executableName: (CommandLine.arguments[0] as NSString).lastPathComponent)
    exit(EXIT_FAILURE)
}

let infoFileName = CommandLine.arguments[1]
ConsoleOutput().write(infoFileName)
let infoFileUrl = URL(fileURLWithPath: infoFileName)
let dir = infoFileUrl.deletingLastPathComponent()
let exportDir = dir.appendingPathComponent("unpacked")

do {
    let unpacker = Unpacker()
    let images = try unpacker.unpack(infoFileUrl: infoFileUrl)
    
    let imageWriter = try ImageWriter(exportFolder: exportDir)
    try images.forEach {
        try imageWriter.save(ciImage: $1, name: $0)
    }
    
} catch {
    print(error)
}
