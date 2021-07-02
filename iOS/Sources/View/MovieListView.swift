//
//  MovieListView.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2020/06/29.
//  Copyright © 2020 presto. All rights reserved.
//

import SwiftUI

struct MovieListView: View {
    @Binding private var movies: [MoviesResponseModel.Movie]
    @Binding private var sortMethod: SortMethod
    
    init(movies: Binding<[MoviesResponseModel.Movie]>, sortMethod: Binding<SortMethod>) {
        _movies = movies
        _sortMethod = sortMethod
    }
    
    var body: some View {
        List(movies) { movie in
            let destinationViewModel = MovieDetailViewModel(movieID: movie.id, movieTitle: movie.title)
            let destination = MovieDetailView(viewModel: destinationViewModel)

            NavigationLink(destination: destination) {
                let viewModel = MovieListItemViewModel(movie: movie)

                MovieListItemView(viewModel: viewModel)
            }
        }
    }
}

// MARK: - Preview

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView(movies: .constant([.dummy]), sortMethod: .constant(.curation))
    }
}
