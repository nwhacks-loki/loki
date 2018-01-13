//
//  ViewController.swift
//  nwHacks2018
//
//  Created by Nathan Tannar on 1/13/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    var blendShapes = [ARFaceAnchor.BlendShapeLocation : NSNumber]()
    
    // MARK: - Initialization
 
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configureFaceTracking()
    }
    
    // MARK: - ARKit
    
    private func configureFaceTracking() {
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        let sceneView = ARSCNView(frame: view.bounds)
        sceneView.automaticallyUpdatesLighting = true
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        sceneView.isHidden = true
        sceneView.delegate = self
        view.addSubview(sceneView)
    }
    
    func playChime() {
        AudioServicesPlaySystemSound(1075)
    }

}

extension ViewController: ARSCNViewDelegate {
    
    public func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        blendShapes = faceAnchor.blendShapes
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        let emotion = Emotion.recognized(in: anchor)
        print(emotion)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blendShapes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = Array(blendShapes.keys)[indexPath.row].rawValue
        cell.detailTextLabel?.text = "\(Array(blendShapes.values)[indexPath.row])"
        return cell
    }
}
