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

  @Binding var movies: [MoviesResponse.Movie]
  @Binding var orderType: OrderType

  func makeUIViewController(context: Context) -> MovieUITableViewController {
    let viewController = MovieUITableViewController()
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(context.coordinator,
                             action: #selector(Coordinator.refreshControlValueDidChange(sender:)),
                             for: .valueChanged)
    viewController.refreshControl = refreshControl
    return viewController
  }

  func updateUIViewController(_ uiViewController: MovieUITableViewController, context: Context) {
    uiViewController.movies = movies
  }

  func makeCoordinator() -> Coordinator { Coordinator(self) }

  final class Coordinator: NSObject {

    var parent: MovieTableView

    var cancellables = Set<AnyCancellable>()

    private let apiService: MovieAPIServiceType

    init(_ parent: MovieTableView, apiService: MovieAPIServiceType = MovieAPIService()) {
      self.parent = parent
      self.apiService = apiService
    }

    @objc func refreshControlValueDidChange(sender: UIRefreshControl) {
      apiService.requestMovies(orderType: parent.orderType)
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

struct MovieTableView_Previews: PreviewProvider {
  static var previews: some View {
    MovieTableView(movies: .constant([]), orderType: .constant(.reservation))
  }
}
