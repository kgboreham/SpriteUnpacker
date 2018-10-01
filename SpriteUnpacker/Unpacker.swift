//
//  Unpacker.swift
//  SpriteUnpacker
//
//  Created by Ken Boreham on 12/2/17.
//  Copyright © 2017 Ken Boreham. All rights reserved.
//

import Foundation
import CoreGraphics
import CoreImage

extension CGRect {
    func relative(to image: CIImage) -> CGRect {
        let imageHeight = CGFloat(image.extent.size.height)
        let origin = CGPoint(x: minX, y: imageHeight - minY - height)
        return CGRect(origin: origin, size: size)
    }
}

enum UnpackerError: Error {
    case fileNotFound(URL)
}

class Unpacker {
    private let output: Output
    
    init(output: Output = ConsoleOutput()) {
        self.output = output
    }
    
    func unpack(infoFileUrl: URL) throws -> [(name: String, image: CIImage)] {
        let dir = infoFileUrl.deletingLastPathComponent()
        
        let reader = PackedFileReader()
        let info = try reader.decode(url: infoFileUrl)
        
        let imageFileUrl = URL(fileURLWithPath: info.metadata.textureFileName, relativeTo: dir)
        guard let image = CIImage(contentsOf: imageFileUrl) else {
            throw UnpackerError.fileNotFound(imageFileUrl)
        }
        
        info.frames.forEach { key, sprite in
            print("\(key) - rect: \(sprite.frame), offset: \(sprite.offset), size: \(sprite.sourceSize), colorRect: \(sprite.sourceColorRect)")
        }
        
        return info.frames.map { key, sprite in
            let frame = sprite.frame.relative(to: image)
            
//            let translation = CGAffineTransform(translationX: sprite.sourceColorRect.origin.x, y: sprite.sourceColorRect.origin.y)
//                .translatedBy(x: sprite.offset.x, y: sprite.offset.y)
            
            let origin = CGPoint(x: sprite.frame.origin.x - sprite.sourceColorRect.origin.x, y: sprite.frame.origin.y - sprite.sourceColorRect.origin.y)
            let rect = CGRect(origin: origin, size: sprite.sourceSize).relative(to: image)
            
            let sprite = image
                .cropped(to: frame)
                .composited(over: CIImage(color: .clear))
//                .transformed(by: translation)
                .cropped(to: rect)
            
            return (key, sprite)
        }
    }
}
