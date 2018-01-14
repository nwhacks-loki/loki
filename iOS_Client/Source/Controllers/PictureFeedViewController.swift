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

class PictureFeedViewController: UICollectionViewController {
    
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
    
    // MARK: - Initialization
    
    public init() {
        let layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: layout)
        title = "Demo"
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.contentInset.top = 10
        collectionView?.backgroundColor = UIColor(hex: "f7f7f7")
        view.addSubview(sceneView)
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.reuseIdentifier)
        
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.setStyleColor(UIColor(hex: "3b5998").darker(by: 10))
        searchBar.isUserInteractionEnabled = false
        searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        navigationItem.titleView = searchBar
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "fb_messenger"), style: .plain, target: nil, action: nil)
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
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1000
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.reuseIdentifier, for: indexPath) as! FeedCell
        
        cell.header.textLabel.text = Randoms.randomFakeName()
        cell.header.detailTextLabel.text = Randoms.randomDateWithinDaysBeforeToday(30).string(dateStyle: .medium, timeStyle: .short)
        cell.contentTextView.text = Lorem.paragraph()
        
        switch currentEmotion {
        case .happy:
            cell.imageView.image = UIImage(named:("happy\(randomNum)"))
        case .sad:
            cell.imageView.image = UIImage(named:("sad\(randomNum)"))
        case .angry:
            cell.imageView.image = UIImage(named:("angry\(randomNum)"))
        case .surprised:
            cell.imageView.image = UIImage(named:("surprise\(randomNum)"))
        default:
            cell.imageView.image = UIImage(named:("unknown"))
        }

        return cell
    }
}

extension PictureFeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.width + 140)
    }
}

public extension UISearchBar {
    
    public func setStyleColor(_ color: UIColor) {
        tintColor = color.isLight ? .black : .white
        
        guard let tf = (value(forKey: "searchField") as? UITextField) else { return }
        let textFieldInsideSearchBarLabel = tf.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = color.isLight ? .black : .white
        
        tf.layer.cornerRadius = 18
        tf.clipsToBounds = true
        tf.textColor = color.isLight ? .black : .white
        tf.backgroundColor = color
        if let glassIconView = tf.leftView as? UIImageView, let img = glassIconView.image {
            let newImg = img.blendedByColor(color.isLight ? .black : .white)
            glassIconView.image = newImg
        }
        if let clearButton = tf.value(forKey: "clearButton") as? UIButton {
            clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
            clearButton.tintColor = color.isLight ? .black : .white
        }
    }
}

extension UIImage {
    
    public func blendedByColor(_ color: UIColor) -> UIImage {
        let scale = UIScreen.main.scale
        if scale > 1 {
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
        } else {
            UIGraphicsBeginImageContext(size)
        }
        color.setFill()
        let bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIRectFill(bounds)
        draw(in: bounds, blendMode: .destinationIn, alpha: 1)
        let blendedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return blendedImage!
    }
}
