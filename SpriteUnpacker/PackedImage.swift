//
//  PackedImage.swift
//  SpriteUnpacker
//
//  Created by Ken Boreham on 2/17/18.
//  Copyright © 2018 Ken Boreham. All rights reserved.
//

import Foundation
import CoreImage

enum PackedImageError: Error {
    case imageLoadingFailed
}

struct PackedImage {
    let image: CIImage
    
    init(imageUrl: URL) throws {
        guard let image = CIImage(contentsOf: imageUrl) else { throw PackedImageError.imageLoadingFailed }
        self.image = image
    }
}
