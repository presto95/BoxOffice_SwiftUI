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
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), alignment: .top), count: 2)) {
                ForEach(movies) { movie in
                    let destinationViewModel = MovieDetailViewModel(movieID: movie.id, movieTitle: movie.title)
                    let destination = MovieDetailView(viewModel: destinationViewModel)
                    NavigationLink(destination: destination) {
                        let viewModel = MovieGridCellModel(movie: movie)

                        MovieGridCell(viewModel: viewModel)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 6)
        }
    }
}

// MARK: - Preview

struct MovieGridView_Previews: PreviewProvider {
    static var previews: some View {
        MovieGridView(movies: .constant([.dummy]), sortMethod: .constant(.curation))
    }
}
