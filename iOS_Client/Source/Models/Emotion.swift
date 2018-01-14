//
//  Emotion.swift
//  nwHacks2018
//
//  Created by Nathan Tannar on 1/13/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import Foundation
import ARKit

enum Emotion: String, Codable {
    
    case happy = "happy" // corners of mouth are raised
    case sad = "sad" // corners of mouth are dropped
    case angry = "angry" // inner corners of eyebrows are dropped
    case surprised = "surprised" // eyebrows are raised, mouth open
    case unknown = "unknown"
    
    /// Set how much smile do you need from a user. 0.8 is kind of hard already!
//    static var successTreshold: CGFloat = 0.7
//
//    static func recognized(in anchor: ARAnchor) -> Emotion {
//
//        guard let faceAnchor = anchor as? ARFaceAnchor else { return .unknown }
//        let blendShapes = faceAnchor.blendShapes
//
//
//        print(blendShapes)
//
//        if let left = blendShapes[.eyeWideLeft], let right = blendShapes[.mouthSmileRight] {
//
//            let smileParameter = min(max(CGFloat(truncating: left), CGFloat(truncating: right))/successTreshold, 1.0)
//            print(smileParameter)
//        }
//
//
//        return .unknown
//    }
}
