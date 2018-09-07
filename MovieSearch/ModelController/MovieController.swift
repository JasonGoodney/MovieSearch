//
//  File.swift
//  MovieSearch
//
//  Created by Jason Goodney on 9/7/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import UIKit

class MovieController {
    
    static let shared = MovieController() ; private init() {}
    
    // MARK: - Properties
    var movies: [Movie]?
    
    // MARK: - Data Fetchers
    func fetchMovies(withSearchText searchText: String, completion: @escaping (_ success: Bool) -> Void) {
        guard let baseURL = URL(string: MovieDBDev.searchBaseURL) else { print("Base url ain't 🔪 it.") ; return }
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let apiKeyQueryItem = URLQueryItem(name: "api_key", value: MovieDBDev.apiKey)
        let searchQueryItem = URLQueryItem(name: "query", value: searchText)
        urlComponents?.queryItems = [apiKeyQueryItem, searchQueryItem]
        
        guard let url = urlComponents?.url else { print("👎 api key") ; completion(false) ; return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            do {
                if let error = error { completion(false) ; throw error }
                guard let data = data else { print("This data is a no go 🛑") ; completion(false) ; throw NSError() }
                
                let jsonDictionary = try JSONDecoder().decode(JSONDictionary.self, from: data)
                
                self.movies = jsonDictionary.movies
                completion(true)
                
            } catch let error {
                print("😳\nThere was an error in \(#function): \(error)\n\n\(error.localizedDescription)\n👿")
                completion(false) ; return
            }
        }.resume()
    }
    
    func fetchImage(from url: URL, completion: @escaping (UIImage?) -> Void) {

        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            do {
                if let error = error { throw error }
                guard let data = data else { print("This data is a no go 🛑") ; throw NSError() }
                
                let image = UIImage(data: data)
                
                completion(image)
                
            } catch let error {
                print("🎅🏻\nThere was an error in \(#function): \(error)\n\n\(error.localizedDescription)\n🎄")
            }
        }.resume()
    }
    
    func imageURL(endpoint: String) -> URL? {
        guard let url = URL(string: MovieDBDev.imageBaseURL)?
            .appendingPathComponent(endpoint) else { return nil }
        
        return url
    }
}
