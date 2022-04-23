//
//  APIService.swift
//  myMovieList
//
//  Created by Zhiyi Chen on 4/1/22.
//

import Foundation

class ApiService {
    private var dataTask: URLSessionDataTask?
    
    func getPopularMoviesData(completion: @escaping (Result<MoviesData, Error>) -> Void) {
        let popularMoviesURL = "https://api.themoviedb.org/3/movie/popular?api_key=5500afde12ee9320ce1ca032c03b6165&language=en-US&page=1"
        
        guard let url = URL(string: popularMoviesURL) else { return }
        
        // Create URLSession working in the background
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Handle error
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                // Handle empty response
                print("Empty response")
                return
            }
            print("Response status code: \(response.statusCode)")
            
            guard let data = data else {
                // Handle empty data
                print("Empty Data")
                return
            }
            
            do {
                // Parse the data
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(MoviesData.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            } catch let error {
                completion(.failure(error))
            }
        }
        dataTask?.resume()
    }
}



//extension UIImageView {
//    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
//        contentMode = mode
//        URLSession.shared.dataTask(with: url) {
//            data, response, error in
//            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode = 200,
//                  let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                  let data = data, error = nil,
//                  let image = UIImage(data: data)
//            else { return }
//            DispatchQueue.main.async {
//                self.image = image
//            }
//        }.resume()
//    }
//}
