//
//  Movie.swift
//  MovieSearch
//
//  Created by Jason Goodney on 9/7/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import Foundation

struct JSONDictionary: Decodable {
    let movies: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

struct Movie: Decodable {
    let rating: Double
    let title: String
    let summary: String
    let poster: String
    
    private enum CodingKeys: String, CodingKey {
        case title
        case rating = "vote_average"
        case summary = "overview"
        case poster = "poster_path"
    }
}
