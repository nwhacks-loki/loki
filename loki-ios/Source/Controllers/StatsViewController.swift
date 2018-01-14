//
//  StatsViewController.swift
//  nwHacks2018
//
//  Created by Nathan Tannar on 1/14/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import CoreML

class StatsViewController: UIViewController {
    
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
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.isUserInteractionEnabled = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var records = [FaceRecord]() { didSet { DispatchQueue.main.async { self.parseRecords() } } }
    
    var emotionDistribution: [Emotion:Double] = [:]
    
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
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(tableView)
        
        titleLabel.anchorCenterXToSuperview()
        titleLabel.anchorCenterYToSuperview(constant: -200)
        subtitleLabel.anchorCenterXToSuperview()
        subtitleLabel.anchor(titleLabel.bottomAnchor)
        tableView.anchor(subtitleLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor)
        
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
        
        let recordCount = records.count
        subtitleLabel.text = "\(recordCount) Records"
        emotionDistribution.removeAll(keepingCapacity: true)
        
        for record in records {
            let currentValue = emotionDistribution[record.emotion] ?? 0
            emotionDistribution[record.emotion] = currentValue + 1
        }
        
        tableView.reloadData()
    }
    
}


extension StatsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emotionDistribution.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        let emotion = Array(emotionDistribution.keys)[indexPath.row]
        let percent = Array(emotionDistribution.values)[indexPath.row] / Double(records.count)
        
        cell.textLabel?.text = emotion.rawValue.capitalized
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        cell.detailTextLabel?.text = "\(Double(round(1000*percent)/1000)*100)%" // 3 decimal places
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}



