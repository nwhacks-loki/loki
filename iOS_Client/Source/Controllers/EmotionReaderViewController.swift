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
    
    var currentEmotion: Emotion = .unknown {
        didSet {
            subtitleLabel.text = currentEmotion.rawValue.capitalized
        }
    }
    
    var emotionProbabilities: [Emotion:Float] = [
        .happy:0,
        .sad:0,
        .angry:0,
        .surprised:0
        ] {
        didSet {
            tableView.reloadData()
        }
    }
    
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
        
//        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        
    }
}

extension EmotionReaderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emotionProbabilities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        let emotion = Array(emotionProbabilities.keys)[indexPath.row]
        let probability = Array(emotionProbabilities.values)[indexPath.row]
        
        cell.textLabel?.text = emotion.rawValue.capitalized
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        cell.detailTextLabel?.text = "\(probability)"
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        if currentEmotion == emotion {
            cell.detailTextLabel?.textColor = .green
        } else if probability < 0.25 {
            cell.detailTextLabel?.textColor = .red
        } else {
            cell.detailTextLabel?.textColor = .orange
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

