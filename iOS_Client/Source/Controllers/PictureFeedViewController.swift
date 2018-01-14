//
//  PictureFeedViewController.swift
//  nwHacks2018
//
//  Created by MAC on 2018-01-13.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import CoreML
import ARKit

class PictureFeedViewController: UITableViewController {
    
    var emotionModel = EmotionModel()
    
    var currentEmotion: Emotion = .unknown
    
    let threshhold: Double = 0.7
    
    var emotionProbabilities: [Emotion:NSNumber] = [
        .happy:0,
        .sad:0,
        .angry:0,
        .surprised:0
    ]
    
    var faceTrackingConfig: ARFaceTrackingConfiguration {
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        return configuration
    }
    
    lazy var sceneView: ARSCNView = {
        let sceneView = ARSCNView(frame: view.bounds)
        sceneView.automaticallyUpdatesLighting = true
        sceneView.isHidden = true
        sceneView.delegate = self
        return sceneView
    }()
    
    var session: ARSession {
        return sceneView.session
    }
    
    var randomNum: UInt32 {
        return arc4random_uniform(4) + 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Emotion Predictor"
        view.backgroundColor = .white
        view.addSubview(sceneView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        pauseCapture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        resumeCapture()
    }
    
    func resumeCapture() {
        
        session.run(faceTrackingConfig, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func pauseCapture() {
        
        session.pause()
    }
    
}

extension PictureFeedViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        let blendShapes = faceAnchor.blendShapes
        
        let sortedKeys = Array(blendShapes.keys).sorted { (lhs, rhs) -> Bool in
            return lhs.rawValue < rhs.rawValue
        } // ["A", "D", "Z"]
        
        print(sortedKeys.map { return $0.rawValue } )
        
        let mlInputArray = try! MLMultiArray(shape: [51], dataType: .double)
        
        let valueArray: [NSNumber] = sortedKeys.map { blendShapes[$0]! }
        valueArray.enumerated().forEach { (offset, element) in
            mlInputArray[offset] = element
        }
        let emotionModelInput = EmotionModelInput(input1: mlInputArray)
        let prediction = try! emotionModel.prediction(input: emotionModelInput)
        
        // order: happy, sad, angry, surprised
        emotionProbabilities[.happy] = prediction.output1[0]
        emotionProbabilities[.sad] = prediction.output1[1]
        emotionProbabilities[.angry] = prediction.output1[2]
        emotionProbabilities[.surprised] = prediction.output1[3]
        
        let highestSet = emotionProbabilities.sorted(by: { (lhs, rhs) -> Bool in
            return lhs.value.doubleValue > rhs.value.doubleValue
        })[0]
        
        if highestSet.value.doubleValue >= threshhold {
            currentEmotion = highestSet.key
        } else {
            currentEmotion = .unknown
        }
    }
}

extension PictureFeedViewController {
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1000
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch currentEmotion {
        case .happy:
            cell.imageView?.image = UIImage(named:("happy\(randomNum)"))
        case .sad:
            cell.imageView?.image = UIImage(named:("sad\(randomNum)"))
        case .angry:
            cell.imageView?.image = UIImage(named:("angry\(randomNum)"))
        case .surprised:
            cell.imageView?.image = UIImage(named:("surprise\(randomNum)"))
        default:
            cell.imageView?.image = UIImage(named:("unknown"))
        }

        return cell
    }
    
}
