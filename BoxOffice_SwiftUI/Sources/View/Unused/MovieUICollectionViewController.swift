//
//  MovieUICollectionViewController.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/17.
//  Copyright © 2019 presto. All rights reserved.
//

import SwiftUI
import UIKit

final class MovieUICollectionViewController: UICollectionViewController {
  var movies = [MoviesResponseModel.Movie]()

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .systemBackground
    collectionView.register(UINib(nibName: "MovieUICollectionViewCell", bundle: nil),
                            forCellWithReuseIdentifier: "movieCollectionCell")
  }

  override func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCollectionCell",
                                                  for: indexPath)
    let movie = movies[indexPath.item]
    if case let movieCell as MovieUICollectionViewCell = cell {
      movieCell.configure(with: movie)
    }
    return cell
  }

  override func collectionView(_: UICollectionView,
                               numberOfItemsInSection _: Int) -> Int { movies.count }

  override func collectionView(_ collectionView: UICollectionView,
                               didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    let movie = movies[indexPath.item]
    let viewModel = MovieDetailViewModel(movieID: movie.id)
    let nextView = UIHostingController(rootView: MovieDetailView(viewModel: viewModel))
    navigationController?.pushViewController(nextView, animated: true)
  }
}

extension MovieUICollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_: UICollectionView,
                      layout _: UICollectionViewLayout,
                      sizeForItemAt _: IndexPath) -> CGSize {
    let width = UIScreen.main.bounds.width
    let itemWidth = width / 2 - 4
    let itemHeight = itemWidth * 1.8
    return CGSize(width: itemWidth, height: itemHeight)
  }

  func collectionView(_: UICollectionView,
                      layout _: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt _: Int) -> CGFloat { 8 }

  func collectionView(_: UICollectionView,
                      layout _: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt _: Int) -> CGFloat { 4 }
}
