//
//  ViewController.swift
//  JSONParsingPractice
//
//  Created by Андрей През on 24.08.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private var timer: Timer?
    var searchResponse: SearchResponse? = nil
    let networkDataFetcher = NetworkDataFetcher()
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearchBar()
    }
    

    
    
    func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

    }
}



extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResponse?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TrackTableViewCell
        cell.trackName.text = searchResponse?.results[indexPath.row].trackName
        cell.collectionName.text = searchResponse?.results[indexPath.row].collectionName
        cell.artistName.text = searchResponse?.results[indexPath.row].artistName
        
        
        
        
        
        return cell
    }
}



extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let urlString = "https://itunes.apple.com/search?term=\(searchText)&limit=5"
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkDataFetcher.fetchData(urlString: urlString) { (result) in
                guard let result = result else { return }
                self.searchResponse = result
                self.tableView.reloadData()
            }
        })
    }
    
}
