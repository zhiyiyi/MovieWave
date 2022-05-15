//
//  MovieModel.swift
//  myMovieList
//
//  Created by Zhiyi Chen on 3/31/22.
//

import Foundation

struct Movie: Decodable {
    
    let backdropPath: String?
    let genres: [MovieGenre]?
    var genreText: String {
        genres?.first?.name ?? "n/a"
    }
    let id: Int?
    let title: String?
    let overview: String?
    let posterPath: String?
    let releaseDate: String?
    let voteAverage: Double?
    var ratingText: String {
        let rating = Int(voteAverage!)
        let remain = 10 - rating
        var ratingText = (0..<rating).reduce("") { (acc, _) -> String in
            return acc + "★"
        }
        ratingText += (0..<remain).reduce("") { (acc, _) -> String in
            return acc + "☆"
        }
        return ratingText
    }
    
    enum CodingKeys: String, CodingKey {
        //case adult
        case backdropPath = "backdrop_path"
        // case genreIDS = "genre_ids"
        case genres
        case id
        // case originalLanguage = "original_language"
        case title = "original_title"
        case overview //, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        // case title, video
        case voteAverage = "vote_average"
        // case voteCount = "vote_count"
    }
}

struct MovieGenre: Decodable {
    let name: String
}

struct MovieList: Decodable {
    let movies: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

struct MovieSimple {
    let title: String
    let rate: Double
    let posterPath: String?
    let numOfReviews: Int
}
