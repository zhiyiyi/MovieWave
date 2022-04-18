//
//  JSONDate.swift
//  myMovieList
//
//  Created by Zhiyi Chen on 3/31/22.
//

import Foundation

func downloadJSON(completed: @escaping () -> ()) {
    let url = URL(string:"https://api.themoviedb.org/3/movie/popular?api_key=8520a5c87b0590da7b111e7d60071aba")

    URLSession.shared.dataTask(with: url!) {
        (data, response, err) in
        if err == nil {
            guard let jsondata = data else { return }
            do {
                self.results = try JSONDecoder().decode(MovieResults.self, from: jsondata)
                DispatchQueue.main.async {
                    completed()
                }
            } catch {
                print("JSON Downloading Error!")
            }
        }
    }.resume()
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) {
            data, response, error in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode = 200,
                  let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                  let data = data, error = nil,
                  let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
