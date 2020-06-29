//
//  MovieUITableViewController.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/17.
//  Copyright © 2019 presto. All rights reserved.
//

import SwiftUI
import UIKit

final class MovieUITableViewController: UITableViewController {
  var movies = [MoviesResponseModel.Movie]()

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UINib(nibName: "MovieUITableViewCell", bundle: nil),
                       forCellReuseIdentifier: "movieTableCell")
  }

  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "movieTableCell", for: indexPath)
    let movie = movies[indexPath.row]
    if case let movieCell as MovieUITableViewCell = cell {
      movieCell.configure(with: movie)
    }
    return cell
  }

  override func tableView(_: UITableView,
                          numberOfRowsInSection _: Int) -> Int { movies.count }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let movie = movies[indexPath.row]
    let viewModel = MovieDetailViewModel(movieID: movie.id)
    let nextView = UIHostingController(rootView: MovieDetailView(viewModel: viewModel))
    navigationController?.pushViewController(nextView, animated: true)
  }
}
