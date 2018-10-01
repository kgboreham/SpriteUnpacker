//
//  ImageWriter.swift
//  SpriteUnpacker
//
//  Created by Ken Boreham on 2/17/18.
//  Copyright © 2018 Ken Boreham. All rights reserved.
//

import Foundation
import CoreImage
import AppKit

struct ImageWriter {
    let exportFolder: URL
    
    init(exportFolder: URL) throws {
        self.exportFolder = exportFolder
        
        if !FileManager.default.fileExists(atPath: exportFolder.path, isDirectory: nil) {
            try FileManager.default.createDirectory(at: exportFolder, withIntermediateDirectories: false, attributes: [:])
        }
    }
    
    func save(ciImage: CIImage, name: String) throws {
        guard ciImage.extent.size != .zero else { return }
        let bitmap = NSBitmapImageRep(ciImage: ciImage)
        let data = bitmap.representation(using: .png, properties: [:])
        try data?.write(to: exportFolder.appendingPathComponent(name + ".png"))
    }
}

