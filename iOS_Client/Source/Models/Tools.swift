//
//  Tools.swift
//  nwHacks2018
//
//  Created by Nathan Tannar on 1/14/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import Foundation
import CoreML

class Tools {
    
    let bitMapInfo: CGBitmapInfo
    let bitsPerComponent: Int
    
    init() {
        bitMapInfo = .byteOrder16Little
        bitsPerComponent = 8
    }
    
    /**
     * Convert a MLMultiarray, containig Doubles, to a bytearray.
     */
    func convert(_ data: MLMultiArray) -> [UInt8] {
        
        var byteData: [UInt8] = []
        
        for i in 0..<data.count {
            let out = data[i]
            let floatOut = out as! Float32
            
            let byteOut: UInt8 = UInt8((floatOut * 127.5) + 127.5)
            byteData.append(byteOut)
        }
        
        return byteData
        
    }
    
    
    /**
     * Create a CGImage from a bytearray.
     */
    func createImage(data: [UInt8], width: Int, height: Int, components: Int) -> CGImage? {
        let colorSpace: CGColorSpace
        switch components {
        case 1:
            colorSpace = CGColorSpaceCreateDeviceGray()
            break
        case 3:
            colorSpace = CGColorSpaceCreateDeviceRGB()
            break
        default:
            fatalError("Unsupported number of components per pixel.")
        }
        
        let cfData = CFDataCreate(nil, data, width*height*components*bitsPerComponent / 8)!
        let provider = CGDataProvider(data: cfData)!
        
        let image = CGImage(width: width,
                            height: height,
                            bitsPerComponent: bitsPerComponent, //
            bitsPerPixel: bitsPerComponent * components, //
            bytesPerRow: ((bitsPerComponent * components) / 8) * width, // comps
            space: colorSpace,
            bitmapInfo: bitMapInfo,
            provider: provider,
            decode: nil,
            shouldInterpolate: false,
            intent: CGColorRenderingIntent.defaultIntent)!
        
        return image
        
    }
    
    
    func toByteArray<T>(_ value: T) -> [UInt8] {
        var value = value
        return withUnsafeBytes(of: &value) { Array($0) }
    }
    
    class func timeIt(code: () -> Void) {
        let time = Date().timeIntervalSince1970
        code()
        let timing = UInt64((Date().timeIntervalSince1970 - time) * 1000)
        print("Run time: \(timing) ms")
    }
    
    class func replaceFile(at path: URL, withFileAt otherPath: URL) {
        do {
            Tools.deleteFile(atPath: path)
            try FileManager.default.copyItem(at: otherPath, to: path)
        }
        catch let error {
            print(error)
        }
    }
    
    
    class func deleteFile(atPath path: URL) {
        print("Trying to remove item at: " + path.absoluteString)
        do {
            try FileManager.default.removeItem(at: path)
            print("File removed")
        }
        catch let error {
            print("Failed to remove item")
            print(error)
        }
    }
}
