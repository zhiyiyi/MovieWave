//
//  MovieModel.swift
//  myMovieList
//
//  Created by Zhiyi Chen on 3/31/22.
//

import Foundation

struct MoviesData: Decodable {
    let movies: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

struct Movie: Decodable {
    
    let id: Int?
    let title: String?
    let year: String?
    let rate: Double?
    let posterImage: String?
    let backdropPath: String?
    let overview: String?
    let genres: [MovieGenre]?
    
    var genreText: String {
        genres?.first?.name ?? "n/a"
    }
    
    var ratingText: String {
        let rating = Int(rate!)
        let remain = 10 - rating
        var ratingText = (0..<rating).reduce("") { (acc, _) -> String in
            return acc + "★"
        }
        ratingText += (0..<remain).reduce("") { (acc, _) -> String in
            return acc + "☆"
        }
        return ratingText
    }
    
    private enum CodingKeys: String, CodingKey {
        case title, overview, id
        case year = "release_date"
        case rate = "vote_average"
        case posterImage = "poster_path"
        case backdropPath = "backdrop_path"
        case genres = "genres"
    }
}

struct MovieGenre: Decodable {
    let name: String
}
