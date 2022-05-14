//
//  APIService.swift
//  myMovieList
//
//  Created by Zhiyi Chen on 4/1/22.
//

import Foundation
import UIKit

final class ApiService {
    static let shared = ApiService()
    
    func getMoviesDataFrom(with url: URL, completion: @escaping (Result<MovieList, Error>) -> Void) {
        // Create URLSession working in the background
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error { // Handle error
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            guard let response = response as? HTTPURLResponse else { // Handle empty response
                print("Empty response")
                return
            }
            print("Response status code: \(response.statusCode)")
            guard let data = data else {// Handle empty data
                print("Empty Data")
                return
            }
            do {// Parse the data
                let jsonData = try JSONDecoder().decode(MovieList.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getMovieDataFrom(url: URL, completion: @escaping (Movie) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Handle empty data
            guard let data = data else {
                print("Empty Data")
                return
            }
            // Handle error
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            do {
                let jsonData = try JSONDecoder().decode(Movie.self, from: data)
                DispatchQueue.main.async {
                    completion(jsonData)
                }
            } catch {
                print("JSON Downloading Error!")
            }
        }.resume()
    }
    // Get image data
    func getImageDataFrom(url: URL, completion: @escaping (UIImage) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("Empty Data")
                return
            }
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(UIImage(named: "noimage")!)
                }
            }
        }.resume()
    }
}
