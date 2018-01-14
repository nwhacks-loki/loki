//
//  EmotionReaderViewController.swift
//  nwHacks2018
//
//  Created by Nathan Tannar on 1/13/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import ARKit
import CoreML

class EmotionReaderViewController: UIViewController {
    
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
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.textAlignment = .center
        label.textColor = .darkGray
        label.text = "Current Emotion"
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        label.textAlignment = .center
        label.text = "Unknown"
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.isUserInteractionEnabled = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Emotion Reader"
        view.backgroundColor = .white
        view.addSubview(sceneView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(tableView)
        
        titleLabel.anchorCenterXToSuperview()
        titleLabel.anchorCenterYToSuperview(constant: -200)
        subtitleLabel.anchorCenterXToSuperview()
        subtitleLabel.anchor(titleLabel.bottomAnchor)
        tableView.anchor(subtitleLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, insets: .zero)
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

extension EmotionReaderViewController: ARSCNViewDelegate {
    
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
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.subtitleLabel.text = self.currentEmotion.rawValue.capitalized
        }
    }
}

extension EmotionReaderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emotionProbabilities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        let emotion = Array(emotionProbabilities.keys)[indexPath.row]
        let probability = Array(emotionProbabilities.values)[indexPath.row].doubleValue
        
        cell.textLabel?.text = emotion.rawValue.capitalized
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        cell.detailTextLabel?.text = "\(probability)"
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        if currentEmotion == emotion {
            cell.detailTextLabel?.textColor = .green
        } else if probability < threshhold && probability > 0.25 {
            cell.detailTextLabel?.textColor = .orange
        } else {
            cell.detailTextLabel?.textColor = .red
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

