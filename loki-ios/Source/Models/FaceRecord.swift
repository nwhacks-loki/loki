//
//  FaceRecord.swift
//  nwHacks2018
//
//  Created by Nathan Tannar on 1/13/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import Foundation
import ARKit

/*
 let jsonData = jsonString.data(encoding: .utf8)!
 let decoder = JSONDecoder()
 let record = try! decoder.decode(FaceRecord.self, for: jsonData)
 
 let encoder = JSONEncoder()
 let data = try! encoder.encode(record)

*/

class FaceRecord: Codable {
    
    // AR Face Anchor Points
    
    var emotion: Emotion
    
    var mouthUpperUp_R: Double
    var mouthPress_L: Double
    var mouthLowerDown_L: Double
    var browDown_L: Double
    var cheekPuff: Double
    var mouthShrugLower: Double
    var eyeLookUp_R: Double
    var jawLeft: Double
    var eyeBlink_L: Double
    var eyeLookIn_L: Double
    var eyeLookOut_R: Double
    var mouthShrugUpper: Double
    var mouthFrown_L: Double
    var jawForward: Double
    var eyeSquint_R: Double
    var mouthStretch_L: Double
    var eyeWide_L: Double
    var jawRight: Double
    var cheekSquint_R: Double
    var jawOpen: Double
    var noseSneer_R: Double
    var browOuterUp_L: Double
    var eyeWide_R: Double
    var eyeLookDown_R: Double
    var browOuterUp_R: Double
    var mouthSmile_R: Double
    var mouthPress_R: Double
    var mouthClose: Double
    var cheekSquint_L: Double
    var eyeLookDown_L: Double
    var mouthRight: Double
    var mouthRollUpper: Double
    var eyeSquint_L: Double
    var mouthRollLower: Double
    var mouthStretch_R: Double
    var mouthDimple_L: Double
    var mouthUpperUp_L: Double
    var mouthPucker: Double
    var noseSneer_L: Double
    var browDown_R: Double
    var browInnerUp: Double
    var mouthLowerDown_R: Double
    var eyeLookUp_L: Double
    var eyeLookIn_R: Double
    var mouthFunnel: Double
    var mouthFrown_R: Double
    var eyeLookOut_L: Double
    var mouthLeft: Double
    var mouthDimple_R: Double
    var eyeBlink_R: Double
    var mouthSmile_L: Double
    
    class func create(for emotion: Emotion, anchors: [ARFaceAnchor.BlendShapeLocation : NSNumber]) -> FaceRecord? {
        
        var json = [String:Any]()
        anchors.forEach { (arg) in
            let (key, value) = arg
            json[key.rawValue] = value.doubleValue
        }
        json["emotion"] = emotion.rawValue
        
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: .sortedKeys) else {
            return nil
        }
        let decoder = JSONDecoder()
        let record = try? decoder.decode(FaceRecord.self, from: data)
        return record
    }
    
    func saveInBackground() {
        
        let endpoint = "http://nw-loki.tech:5001/post-emotion"
        guard let data = try? JSONEncoder().encode(self), let url = URL(string: endpoint) else {
            print("something went wrong")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = data
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // there was an error
                Ping(text: error.localizedDescription, style: .danger).show()
            } 
        }.resume()
    }
    
}
