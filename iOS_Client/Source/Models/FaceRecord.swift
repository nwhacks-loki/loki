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
    
    var mouthUpperUp_R: Float
    var mouthPress_L: Float
    var mouthLowerDown_L: Float
    var browDown_L: Float
    var cheekPuff: Float
    var mouthShrugLower: Float
    var eyeLookUp_R: Float
    var jawLeft: Float
    var eyeBlink_L: Float
    var eyeLookIn_L: Float
    var eyeLookOut_R: Float
    var mouthShrugUpper: Float
    var mouthFrown_L: Float
    var jawForward: Float
    var eyeSquint_R: Float
    var mouthStretch_L: Float
    var eyeWide_L: Float
    var jawRight: Float
    var cheekSquint_R: Float
    var jawOpen: Float
    var noseSneer_R: Float
    var browOuterUp_L: Float
    var eyeWide_R: Float
    var eyeLookDown_R: Float
    var browOuterUp_R: Float
    var mouthSmile_R: Float
    var mouthPress_R: Float
    var mouthClose: Float
    var cheekSquint_L: Float
    var eyeLookDown_L: Float
    var mouthRight: Float
    var mouthRollUpper: Float
    var eyeSquint_L: Float
    var mouthRollLower: Float
    var mouthStretch_R: Float
    var mouthDimple_L: Float
    var mouthUpperUp_L: Float
    var mouthPucker: Float
    var noseSneer_L: Float
    var browDown_R: Float
    var browInnerUp: Float
    var mouthLowerDown_R: Float
    var eyeLookUp_L: Float
    var eyeLookIn_R: Float
    var mouthFunnel: Float
    var mouthFrown_R: Float
    var eyeLookOut_L: Float
    var mouthLeft: Float
    var mouthDimple_R: Float
    var eyeBlink_R: Float
    var mouthSmile_L: Float
    
    class func create(for emotion: Emotion, anchors: [ARFaceAnchor.BlendShapeLocation : NSNumber]) -> FaceRecord {
        
        var json = [String:Any]()
        anchors.forEach { (arg) in
            let (key, value) = arg
            json[key.rawValue] = value.floatValue
        }
        json["emotion"] = emotion.rawValue
        
        let data = try! JSONSerialization.data(withJSONObject: json, options: .sortedKeys)
        let decoder = JSONDecoder()
        let record = try! decoder.decode(FaceRecord.self, from: data)
        return record
    }
    
    func saveInBackground() {
        
        let endpoint = "http://54.218.118.144:5001/post-emotion"
        guard let data = try? JSONEncoder().encode(self), let url = URL(string: endpoint) else {
            print("something went wrong")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = data
        
        print("trying to save")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // there was an error
                print(error.localizedDescription)
            } else {
                if let data = data {
                    guard let value = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else { return }
                    print(value)
                }
                
            }
        }.resume()
    }
    
}
