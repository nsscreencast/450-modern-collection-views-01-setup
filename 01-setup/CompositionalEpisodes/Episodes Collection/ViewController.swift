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
    
    private var collectionView: UICollectionView!
    private var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Episodes"
        
        loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.hidesWhenStopped = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: loadingIndicator)
        
        configureCollectionView()
        fetchData()
    }
    
    private func configureCollectionView() {
    
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 300, height: 100)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.dataSource = self
        
        collectionView.register(EpisodeCell.self, forCellWithReuseIdentifier: EpisodeCell.reuseIdentifier)
    }

    private func fetchData() {
        dataLoader.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loadingIndicator.startAnimating()
                } else {
                    self?.loadingIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        dataLoader.dataChanged
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        dataLoader.fetchData()
    }
    
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataLoader.episodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let episodeCell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodeCell.reuseIdentifier, for: indexPath) as! EpisodeCell
        
        // configure the cell
        let episode = dataLoader.episodes[indexPath.row]
        episodeCell.titleLabel.text = episode.title
        episodeCell.subtitleLabel.text = "#\(episode.episodeNumber)"
        episodeCell.imageView.setImage(with: episode.mediumArtworkUrl)
        
        return episodeCell
    }
}
