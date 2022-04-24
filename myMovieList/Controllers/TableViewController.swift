//
//  MovieListViewController.swift
//  myMovieList
//
//  Created by Zhiyi Chen on 3/30/22.
//

import UIKit
import Firebase

class TableViewController: UITableViewController {
    var apiService = ApiService()
    private var viewModel = MovieViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchPopularMoviesData { [weak self] in
            self?.tableView.dataSource = self
            self?.tableView.reloadData()
        }
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didTapLogout))
        ]
        createNavHeader()
    }
    
    @objc func didTapLogout() {
        do {
            try? Auth.auth().signOut()
            let navViewController = self.storyboard?.instantiateViewController(withIdentifier: "loginpage") as? UINavigationController
            self.view.window?.rootViewController = navViewController
            self.view.window?.makeKeyAndVisible()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = viewModel.cellForRowAt(indexPath: indexPath)
        cell.setCellWithValuesOf(movie)
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If the triggered segue is the "showItem" segue
        switch segue.identifier {
        case "showMovie"?:
            if let indexPath = tableView.indexPathForSelectedRow {
                let movie = viewModel.cellForRowAt(indexPath: indexPath)
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.movie = movie
            }
        case "profilephoto1"?:
            return
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    // Delete a movie from the list
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            viewModel.deleteRowAt(indexPath: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func createNavHeader() {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let filename = safeEmail + "_profile_picture.png"
        let path = "images/" + filename
        
        StorageManager.shared.downloadURL(for: path) { [weak self] result in
            switch result {
            case .success(let url):
                self?.downloadProfile(url: url)
            case .failure(let error):
                print("Failed to get download url: \(error)")
            }
        }
    }
    
    func downloadProfile(url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                let button = UIButton(type: .custom)
                button.frame = CGRect(x: 0.0, y: 0.0, width: 24, height: 24)
                button.setImage(image, for: .normal)
                button.addTarget(self, action: #selector(self.didTapProfilePhoto), for: .touchUpInside)
                let barButtonItem = UIBarButtonItem(customView: button)
                let currWidth = barButtonItem.customView?.widthAnchor.constraint(equalToConstant: 24)
                currWidth?.isActive = true
                let currHeight = barButtonItem.customView?.heightAnchor.constraint(equalToConstant: 24)
                currHeight?.isActive = true
                self.navigationItem.rightBarButtonItems?.append(barButtonItem)
            }
        }.resume()
    }
    
    @objc func didTapProfilePhoto() {
        do {
            performSegue(withIdentifier: "profilephoto1", sender: self)
        }
    }
}
