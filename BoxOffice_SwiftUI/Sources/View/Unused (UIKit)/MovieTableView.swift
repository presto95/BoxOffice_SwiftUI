//
//  MovieTableView.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/17.
//  Copyright © 2019 presto. All rights reserved.
//

import Combine
import SwiftUI

struct MovieTableView: UIViewControllerRepresentable {
  @Binding private var movies: [MoviesResponseModel.Movie]
  @Binding private var sortMethod: SortMethod

  init(movies: Binding<[MoviesResponseModel.Movie]>, sortMethod: Binding<SortMethod>) {
    _movies = movies
    _sortMethod = sortMethod
  }

  func makeUIViewController(context: Context) -> MovieUITableViewController {
    let viewController = MovieUITableViewController()
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(context.coordinator,
                             action: #selector(Coordinator.refreshControlValueDidChange(sender:)),
                             for: .valueChanged)
    viewController.refreshControl = refreshControl
    return viewController
  }

  func updateUIViewController(_ uiViewController: MovieUITableViewController, context _: Context) {
    uiViewController.movies = movies
  }

  func makeCoordinator() -> Coordinator { Coordinator(self) }

  final class Coordinator: NSObject {
    private var parent: MovieTableView
    private let apiService: MovieAPIServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(_ parent: MovieTableView, apiService: MovieAPIServiceProtocol = MovieAPIService()) {
      self.parent = parent
      self.apiService = apiService
    }

    @objc fileprivate func refreshControlValueDidChange(sender: UIRefreshControl) {
      apiService.requestMovies(sortMethod: parent.sortMethod)
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { _ in
          sender.endRefreshing()
        }, receiveValue: { moviesResponse in
          self.parent.movies = moviesResponse.movies
        })
        .store(in: &cancellables)
    }
  }
}

// MARK: - Preview

struct MovieTableView_Previews: PreviewProvider {
  static var previews: some View {
    MovieTableView(movies: .constant([.dummy]), sortMethod: .constant(.reservation))
  }
}
