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
    
    case happy = "happy"
    case sad = "sad"
    case angry = "angry"
    case surprised = "surprised"
    case unknown = "unknown"

    static func all() -> [Emotion] {
        return [.happy, .sad, .angry, .surprised]
    }
}
