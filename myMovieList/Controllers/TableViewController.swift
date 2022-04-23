//
//  MovieListViewController.swift
//  myMovieList
//
//  Created by Zhiyi Chen on 3/30/22.
//

import UIKit

class TableViewController: UITableViewController {
    var apiService = ApiService()
    private var viewModel = MovieViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchPopularMoviesData { [weak self] in
            self?.tableView.dataSource = self
            self?.tableView.reloadData()
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
        default:
            preconditionFailure("Unexpected segue identifier.") }
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

}
