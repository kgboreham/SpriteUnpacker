//
//  PackedInfo.swift
//  SpriteUnpacker
//
//  Created by Ken Boreham on 2/17/18.
//  Copyright © 2018 Ken Boreham. All rights reserved.
//

import Foundation

struct PackedMeta: Decodable {
    let textureFileName: String
}

struct PackedInfo: Decodable {
    let metadata: PackedMeta
    let frames: [String: PackedSprite]
}
