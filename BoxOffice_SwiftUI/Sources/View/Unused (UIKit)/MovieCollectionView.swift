//
//  MovieCollectionView.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/17.
//  Copyright © 2019 presto. All rights reserved.
//

import Combine
import SwiftUI

struct MovieCollectionView: UIViewControllerRepresentable {
  @Binding private var movies: [MoviesResponseModel.Movie]
  @Binding private var sortMethod: SortMethod

  init(movies: Binding<[MoviesResponseModel.Movie]>, sortMethod: Binding<SortMethod>) {
    _movies = movies
    _sortMethod = sortMethod
  }

  func makeUIViewController(context: Context) -> MovieUICollectionViewController {
    let layout = UICollectionViewFlowLayout()
    let viewController = MovieUICollectionViewController(collectionViewLayout: layout)
    viewController.collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(context,
                             action: #selector(Coordinator.refreshControlValueDidChange(_:)),
                             for: .valueChanged)
    viewController.collectionView.refreshControl = refreshControl
    return viewController
  }

  func updateUIViewController(_ uiViewController: MovieUICollectionViewController,
                              context _: Context) {
    uiViewController.movies = movies
  }

  func makeCoordinator() -> Coordinator { Coordinator(self) }

  final class Coordinator: NSObject {
    private var parent: MovieCollectionView
    private let apiService: MovieAPIServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(_ parent: MovieCollectionView, apiService: MovieAPIServiceProtocol = MovieAPIService()) {
      self.parent = parent
      self.apiService = apiService
    }

    @objc fileprivate func refreshControlValueDidChange(_ sender: UIRefreshControl) {
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

struct MovieCollectionView_Previews: PreviewProvider {
  static var previews: some View {
    MovieCollectionView(movies: .constant([.dummy]), sortMethod: .constant(.reservation))
  }
}
