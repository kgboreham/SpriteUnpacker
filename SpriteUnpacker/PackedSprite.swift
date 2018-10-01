//
//  PackedSprite.swift
//  SpriteUnpacker
//
//  Created by Ken Boreham on 2/17/18.
//  Copyright © 2018 Ken Boreham. All rights reserved.
//

import Foundation

struct PackedSprite: Decodable {
    let frame: CGRect
    let offset: CGPoint
    let sourceSize: CGSize
    
    let rotated: Bool
    let sourceColorRect: CGRect
    
    enum CodingKeys: CodingKey {
        case frame, offset, sourceSize
        case rotated, sourceColorRect
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let frameString = try container.decode(String.self, forKey: .frame)
        let offsetString = try container.decode(String.self, forKey: .offset)
        let sourceSizeString = try container.decode(String.self, forKey: .sourceSize)
        
        frame = NSRectFromString(frameString)
        offset = NSPointFromString(offsetString)
        sourceSize = NSSizeFromString(sourceSizeString)
        
        if let sourceColorRectString = try container.decodeIfPresent(String.self, forKey: .sourceColorRect) {
            sourceColorRect = NSRectFromString(sourceColorRectString)
        } else {
            sourceColorRect = CGRect(origin: .zero, size: frame.size)
        }
        let rotatedString = try container.decodeIfPresent(String.self, forKey: .rotated) ?? "true"
        rotated = rotatedString.lowercased() == "true"
    }
}
