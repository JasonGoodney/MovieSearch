//
//  MovieSearchViewController.swift
//  MovieSearch
//
//  Created by Jason Goodney on 9/7/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import UIKit

class MovieSearchViewController: UIViewController {
    
    // MARK: - Properties
    var movies: [Movie] {
        return MovieController.shared.movies ?? []
    }
    var rowHeight: CGFloat = 450
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero)
        view.dataSource = self
        view.delegate = self
        view.prefetchDataSource = self
        view.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.cellId)
        view.estimatedRowHeight = rowHeight
        view.rowHeight = UITableViewAutomaticDimension
        return view
    }()

    lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.searchBar.delegate = self
        controller.obscuresBackgroundDuringPresentation = false
        return controller
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        updateView()
        
        displaySearchResults(withSearchText: "Star Wars")
    }
}

// MARK: - Fetch Performer
private extension MovieSearchViewController {
    func displaySearchResults(withSearchText searchText: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        MovieController.shared.fetchMovies(withSearchText: searchText) { (success) in
            if success {
                self.reloadTableView()
            }
        }
    }
}

// MARK: - Update View
private extension MovieSearchViewController {
    func updateView() {
        [tableView].forEach({
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        setupNavigationBar()
        setupConstraints()
    }
    
    func setupNavigationBar() {
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Movie Search"
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}

// MARK: - UITableViewDataSource
extension MovieSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.cellId,
                                                       for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        
        cell.movie = movies[indexPath.row]
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MovieSearchViewController: UITableViewDelegate {

}

// MARK: - UITableViewDataSourcePrefetching
extension MovieSearchViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let movie = movies[indexPath.row]
            
            guard let posterURL = MovieController.shared.imageURL(endpoint: movie.poster) else { return }
            
            URLSession.shared.dataTask(with: posterURL).resume()
        }
    }
}
// MARK: - UISearchResultsUpdating & UISearchBarDelegate
extension MovieSearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        displaySearchResults(withSearchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
    }
}
