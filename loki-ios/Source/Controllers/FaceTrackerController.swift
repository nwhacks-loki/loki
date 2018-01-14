//
//  FaceTrackerController.swift
//  nwHacks2018
//
//  Created by Nathan Tannar on 1/14/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import ARKit

class FaceTrackerController: UIViewController, ARSCNViewDelegate {
    
    var emotionModel: EmotionModel = {
        // Look for sync'd model
        guard let appSupportDirectory = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
            // Fallback
            print("falling back on local model")
            return EmotionModel()
        }
        let expectedURL = appSupportDirectory.appendingPathComponent("EmotionModel.mlmodel")
        guard let model = try? EmotionModel(contentsOf: expectedURL) else {
            // Fallback
            print("falling back on local model")
            return EmotionModel()
        }
        return model
    }()
    
    var faceTrackingConfig: ARFaceTrackingConfiguration {
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        return configuration
    }
    
    lazy var sceneView: ARSCNView = {
        let sceneView = ARSCNView(frame: view.bounds)
        sceneView.automaticallyUpdatesLighting = true
        sceneView.delegate = self
        return sceneView
    }()
    
    var session: ARSession {
        return sceneView.session
    }
    
    // MARK: - Initialization
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        title = "ARKit Demo"
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(sceneView)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        pauseCapture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        resumeCapture()
    }
    
    func pauseCapture() {
        
        session.pause()
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.leftBarButtonItem?.isEnabled = true
    }
    
    @objc
    func resumeCapture() {
        
        session.run(faceTrackingConfig, options: [.resetTracking, .removeExistingAnchors])
        navigationItem.rightBarButtonItem?.isEnabled = true
        navigationItem.leftBarButtonItem?.isEnabled = false
    }
}
