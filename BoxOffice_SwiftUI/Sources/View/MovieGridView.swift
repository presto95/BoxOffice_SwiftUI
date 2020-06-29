//
//  MovieGridView.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2020/06/29.
//  Copyright © 2020 presto. All rights reserved.
//

import SwiftUI

struct MovieGridView: View {
  @Binding private var movies: [MoviesResponseModel.Movie]
  @Binding private var sortMethod: SortMethod
  
  init(movies: Binding<[MoviesResponseModel.Movie]>, sortMethod: Binding<SortMethod>) {
    _movies = movies
    _sortMethod = sortMethod
  }
  
  var body: some View {
    ScrollView {
      LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
        ForEach(movies) { movie in
          NavigationLink(destination: MovieDetailView(viewModel: MovieDetailViewModel(movieID: movie.id))) {
            MovieGridCell(viewModel: MovieGridCellModel(movie: movie))
          }
          .buttonStyle(PlainButtonStyle())
        }
      }
    }
  }
}

// MARK: - Preview

struct MovieGridView_Previews: PreviewProvider {
  static var previews: some View {
    MovieGridView(movies: .constant([.dummy]), sortMethod: .constant(.curation))
  }
}
