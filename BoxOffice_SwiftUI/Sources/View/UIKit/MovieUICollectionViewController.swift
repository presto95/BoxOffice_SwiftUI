//
//  MovieUICollectionViewController.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/17.
//  Copyright © 2019 presto. All rights reserved.
//

import UIKit
import SwiftUI

final class MovieUICollectionViewController: UICollectionViewController {

  var movies = [MoviesResponse.Movie]()

  override func viewDidLoad() {
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

  override func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int { movies.count }

  override func collectionView(_ collectionView: UICollectionView,
                               didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    let movie = movies[indexPath.item]
    let nextView = UIHostingController(rootView: MovieDetailView(movieID: movie.id))
    navigationController?.pushViewController(nextView, animated: true)
  }
}

extension MovieUICollectionViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
     let width = UIScreen.main.bounds.width
     let itemWidth = width / 2 - 4
     let itemHeight = itemWidth * 1.8
     return CGSize(width: itemWidth, height: itemHeight)
   }

   func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       minimumLineSpacingForSectionAt section: Int) -> CGFloat { 8 }

   func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { 4 }
}
