//
//  ViewController.swift
//  CompositionalEpisodes
//
//  Created by Ben Scheirman on 7/22/20.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    private var cancellables: Set<AnyCancellable> = []
    private var dataLoader = DataLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Episodes"
        
        configureCollectionView()
        fetchData()
    }
    
    private func configureCollectionView() {
    
    }

    private func fetchData() {
    }
    
}
