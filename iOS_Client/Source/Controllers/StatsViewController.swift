//
//  StatsViewController.swift
//  nwHacks2018
//
//  Created by Nathan Tannar on 1/14/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import CoreML
import Charts

class StatsViewController: UIViewController {
    
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
    
    var records = [FaceRecord]() { didSet { DispatchQueue.main.async { self.parseRecords() } } }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.textAlignment = .center
        label.textColor = .darkGray
        label.text = "Predictions Based On"
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        label.textAlignment = .center
        label.text = "0 Records"
        return label
    }()
    
    lazy var chartView: PieChartView = {
        let chartView = PieChartView()
        return chartView
    }()
    
    // MARK: - Initialization
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        title = "CoreML Stats"
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(chartView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        
        titleLabel.anchorCenterXToSuperview()
        titleLabel.anchorCenterYToSuperview(constant: -200)
        subtitleLabel.anchorCenterXToSuperview()
        subtitleLabel.anchor(titleLabel.bottomAnchor)
        
        chartView.anchorCenterXToSuperview()
        chartView.anchorCenterYToSuperview(constant: 100)
        chartView.anchor(left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 400)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let endpoint = "http://nwhacks-2018.kevinyap.ca:5001/data"
        let url = URL(string: endpoint)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            if let data = data {
                let records = try? JSONDecoder().decode([FaceRecord].self, from: data)
                self?.records = records ?? []
                
            }
        }.resume()
    }
    
    func parseRecords() {
        
        

//
//        let mlInputArray = try! MLMultiArray(shape: [51], dataType: .double)
//        let valueArray: [NSNumber] = sortedKeys.map { blendShapes[$0]! }
//        valueArray.enumerated().forEach { (offset, element) in
//            mlInputArray[offset] = element
//        }
//        let emotionModelInput = EmotionModelInput(input1: mlInputArray)
//        let prediction = try! emotionModel.prediction(input: emotionModelInput)
    }
    
}


