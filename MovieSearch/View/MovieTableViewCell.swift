//
//  MovieTableViewCell.swift
//  MovieSearch
//
//  Created by Jason Goodney on 9/7/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static var cellId: String {
        return String(describing: MovieTableViewCell.self)
    }
    
    var movie: Movie? {
        didSet {
            updateView()
        }
    }
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    var ratingLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var summaryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    var posterImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private let inset: CGFloat = 16

}

// MARK: - Update View
extension MovieTableViewCell {
    func updateView() {
        
        [titleLabel, ratingLabel, posterImageView, summaryLabel].forEach({
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        setupConstraints()
        
        setSubViewValues()

    }
    
    func setSubViewValues() {
        guard let movie = movie,
            let posterURL = MovieController.shared.imageURL(endpoint: movie.poster) else { return }
        
        titleLabel.text = movie.title
        ratingLabel.text = "\(movie.rating)"
        summaryLabel.text = movie.summary
        
        MovieController.shared.fetchImage(from: posterURL) { (image) in
            DispatchQueue.main.async {
                self.posterImageView.image = image
            }
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
//            titleLabel.bottomAnchor.constraint(equalTo: ratingLabel.topAnchor, constant: -inset),
            
            ratingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: inset),
            ratingLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            ratingLabel.bottomAnchor.constraint(equalTo: posterImageView.topAnchor, constant: inset),
            ratingLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            posterImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            posterImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            posterImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.5),
            
            summaryLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: inset),
            summaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            summaryLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset),
            summaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
        ])
    }
}

