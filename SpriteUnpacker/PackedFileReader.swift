//
//  PackedFileReader.swift
//  SpriteUnpacker
//
//  Created by Ken Boreham on 1/28/18.
//  Copyright © 2018 Ken Boreham. All rights reserved.
//

import Foundation

protocol PackedFileDecoder {
    func decode(_ type: PackedInfo.Type, from data: Data) throws -> PackedInfo
}

extension JSONDecoder: PackedFileDecoder {}
extension PropertyListDecoder: PackedFileDecoder {}

struct PackedFileReader {
    enum FileFormat: String {
        case plist, json
    }
    
//    private func fileUrl(for asset: String) -> URL {
//        let isAbsolute = asset.hasPrefix("/")
//        if isAbsolute {
//            return URL(fileURLWithPath: asset)
//        }
//        let cwd = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
//        return URL(fileURLWithPath: asset, relativeTo: cwd)
//    }
    
    private func fileFormat(url: URL) -> FileFormat {
        return FileFormat(rawValue: url.pathExtension) ?? .plist
    }
    
    private func fileDecoder(type: FileFormat) -> PackedFileDecoder {
        switch type {
        case .json:
            return JSONDecoder()
        case .plist:
            return PropertyListDecoder()
        }
    }
    
    func decode(url: URL) throws -> PackedInfo {
        let location = url
        let format = fileFormat(url: location)
        let decoder = fileDecoder(type: format)
        
        let data = try Data(contentsOf: location)
        let packedInfo = try decoder.decode(PackedInfo.self, from: data)
        
        return packedInfo
    }
}
