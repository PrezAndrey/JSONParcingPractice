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
    let networkService = NetworkService()
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}



extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResponse?.resultCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = searchResponse?.results[indexPath.row].trackName
        
        return cell
    }
}



extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let urlString = "https://itunes.apple.com/search?term=\(searchText)&limit=25"
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkService.request(urlString: urlString) { [weak self] (result) in
                switch result {
                case .failure(let error):
                    print("error: \(error)")
                case .success(let success):
                    self?.searchResponse = success
                    self?.tableView.reloadData()
                }
            }
        })
    }
    
}
