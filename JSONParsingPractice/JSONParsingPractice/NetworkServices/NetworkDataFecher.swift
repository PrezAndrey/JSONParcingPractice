//
//  NetworkDataFecher.swift
//  JSONParsingPractice
//
//  Created by Андрей През on 26.08.2022.
//

import Foundation


class NetworkDataFetcher {
    
    let networkService = NetworkService()
    
    func fetchData(urlString: String, response: @escaping (SearchResponse?) -> Void) {
        networkService.request(urlString: urlString) { (result) in
            switch result {
            case .success(let data):
                do {
                    let tracks = try JSONDecoder().decode(SearchResponse.self, from: data)
                    response(tracks)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                }
            case .failure(let error):
                print("Error recieved requesting data: \(error.localizedDescription)")
                response(nil)
            }
        }
    }
    
    
}
