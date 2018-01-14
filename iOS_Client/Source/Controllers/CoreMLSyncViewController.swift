//
//  CoreMLSyncViewController.swift
//  nwHacks2018
//
//  Created by Nathan Tannar on 1/14/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import CoreML

class CoreMLSyncViewController: UIViewController {
    
    weak var downloadWheel: DownloadWheel?
    
    // MARK: - Initialization
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        title = "CoreML Sync"
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let url = URL(string: "http://54.190.62.122:5001/model")!
        downloadWheel = DownloadWheel().downloadFile(from: url) { [weak self] (wheel, url, error) in
            guard let url = url else {
                Ping(text: error?.localizedDescription ?? "Error", style: .danger)
                return
            }
            self?.replaceEmotionModel(at: url)
        }
        downloadWheel?.present(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        downloadWheel?.dismiss(animated: false)
        downloadWheel = nil
    }
    
    func replaceEmotionModel(at url: URL) {
        
        let compiledUrl = try MLModel.compileModel(at: modelUrl)
        let model = try MLModel(contentsOf: compiledUrl)
    }
}
