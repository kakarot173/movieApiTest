//
//  ViewController.swift
//  movieAssignment
//
//  Created by Animesh Mohanty on 25/05/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit
import Kingfisher
enum tabItems:String {
    case NowPlaying = "Now Playing"
    case TopRated = "Top Rated"
}
class mainTabBar:UITabBarController,UITabBarControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let identifier = item.tag
       
        if identifier == 2{
           CollectionViewController.apiUrl = "https://api.themoviedb.org/3/movie/top_rated?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
        }
        else if identifier == 1{
            CollectionViewController.apiUrl = "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
            
        }
    
}
}
class CollectionViewController: UIViewController {
    
    // https://jsonplaceholder.typicode.com/
    static var apiUrl = "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
    fileprivate let imageApiBaseUrl = "https://image.tmdb.org/t/p/w342"
    // MARK: DataSource & DataSourceSnapshot typealias
    typealias DataSource = UICollectionViewDiffableDataSource<Section,detail>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section,detail>
    
    // MARK: - Properties
    private var collectionView: UICollectionView! = nil
    let search = UISearchController(searchResultsController: nil)
    var detail = detailView()
    // MARK: dataSource & snapshot
    private var dataSource :DataSource!
    private var snapshot = DataSourceSnapshot()
    private var dataArray: [detail]?
    
    var dummyController = UIViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "Movies"
        navigationController?.navigationBar.prefersLargeTitles = false
        // Declare the searchController
        self.navigationItem.searchController = search
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        
        search.searchBar.placeholder = "Search Movies"
        configureCollectionViewLayout()
        configureCollectionViewDataSource()
        
        fetchItems()
    }
    
}

// MARK: - Collection View Delegate
extension CollectionViewController: UICollectionViewDelegate  {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let item = dataSource.itemIdentifier(for: indexPath) else{return}
        let imageUrl = "\(imageApiBaseUrl)\(item.poster_path!)"
        if let url = URL(string: imageUrl) {
            let resource = ImageResource(downloadURL: url)
            
            detail.mainImageView.kf.setImage(with: resource)
            detail.title.text = item.title
            detail.overView.text = item.overview
            detail.releaseDate.text = item.release_date
            detail.ratingLabel.text = "\(Int((item.vote_average ?? 100.0) * 10)) %"
            dummyController.view = detail
            detail.animateIn()
            self.navigationController?.pushViewController(dummyController, animated: true)
        }
    }
    //long press to delete remember
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            return nil
        }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                self.deleteItems(item)
            }
            return UIMenu(title: "Actions", children: [deleteAction])
        })
    }
}


//MARK: - Collection View Setup
extension CollectionViewController {
    
    enum Section {
        case main
    }
    
    private func createLayout() -> UICollectionViewLayout {
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8 , leading: 8, bottom: 8, trailing: 8)
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension:.absolute(166))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        // Section
        let section = NSCollectionLayoutSection(group: group)
        
        // Layout
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureCollectionViewLayout() {
        // TODO: collectionView
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        collectionView.backgroundColor =  UIColor(red: 246/255 , green: 193/255, blue: 173/255, alpha: 1)
        collectionView.register(movieCell.self, forCellWithReuseIdentifier: movieCell.reuseIdentifier)
        view.addSubview(collectionView)
    }
    
    private func configureCollectionViewDataSource() {
        // TODO: dataSource
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexpath, mov) -> movieCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieCell.reuseIdentifier, for: indexpath) as! movieCell
            cell.configure(with: mov)
            return cell
        })
    }
    
    private  func deleteItems(_ item:detail) {
        //        snapshot = DataSourceSnapshot()
        let delay = 0.6 // Seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.snapshot.deleteItems([item])
            self.dataArray?.removeAll(where: {$0 == item})
            self.dataSource.apply(self.snapshot,animatingDifferences: true)
        }
        
        
    }
    private func fetchItems() {
        
        guard let url = URL(string: CollectionViewController.apiUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let fetchedItems = try JSONDecoder().decode(movie.self, from: data)
                        self.dataArray = fetchedItems.dataArray
                        self.applySnapshot(movies: fetchedItems.dataArray)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            } else {
                print("HTTPURLResponse code: \(response.statusCode)")
            }
        }.resume()
        
    }
    
    private func applySnapshot(movies: [detail]) {
        
        snapshot = DataSourceSnapshot()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(movies)
        dataSource.apply(snapshot,animatingDifferences: false)
    }
    
}
//MARK: - Search Functionality

extension CollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        applySnapshot(movies: filteredCells(for: searchBar.text!))
        
        
        
    }
    func filteredCells(for searchQuery: String?)->[detail] {
        if  searchQuery == "" {
            return dataArray ?? []
        }
        else{
            return (dataArray?.filter({($0.title!.contains(searchQuery!))})) ?? []
        }
        
    }
}
