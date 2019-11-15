//
//  MovieView.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/16.
//  Copyright © 2019 presto. All rights reserved.
//

import SwiftUI

struct MovieView: View {
  @ObservedObject private var viewModel = MovieViewModel()

  var body: some View {
    NavigationView {
      TabView(selection: $viewModel.presentationType) {
        movieTableView

        movieCollectionView
      }
      .navigationBarTitle(Text(viewModel.orderTypeDescription), displayMode: .inline)
      .navigationBarItems(trailing: sortButton)
      .actionSheet(isPresented: $viewModel.showsSortActionSheet) { sortActionSheet }
      .onAppear(perform: viewModel.setPresented)
    }
  }
}

extension MovieView {
  var movieTableView: some View {
    Group {
      if viewModel.isLoading {
        ActivityIndicator(isAnimating: $viewModel.isLoading)
      } else if !viewModel.movieErrors.isEmpty {
        MovieRetryView(errors: $viewModel.movieErrors, onRetry: viewModel.retryMovieRequest)
      } else {
        MovieTableView(movies: $viewModel.movies, orderType: $viewModel.orderType)
      }
    }
    .tabItem {
      Image("ic_list")
      Text("Table")
    }
    .tag(MovieViewModel.PresentationType.table)
  }

  var movieCollectionView: some View {
    Group {
      if viewModel.isLoading {
        ActivityIndicator(isAnimating: $viewModel.isLoading)
      } else if !viewModel.movieErrors.isEmpty {
        MovieRetryView(errors: $viewModel.movieErrors, onRetry: viewModel.retryMovieRequest)
      } else {
        MovieCollectionView(movies: $viewModel.movies, orderType: $viewModel.orderType)
      }
    }
    .tabItem {
      Image("ic_collection")
      Text("Collection")
    }
    .tag(MovieViewModel.PresentationType.collection)
  }

  var sortButton: some View {
    Button(action: viewModel.setShowsSortActionSheet) {
      Image("ic_settings")
        .renderingMode(.original)
    }
  }

  var sortActionSheet: ActionSheet {
    ActionSheet(title: Text("정렬방식 선택"),
                message: Text("영화를 어떤 순서로 정렬할까요?"),
                buttons: [
                  .default(Text("예매율")) { self.viewModel.setOrderType(.reservation) },
                  .default(Text("큐레이션")) { self.viewModel.setOrderType(.curation) },
                  .default(Text("개봉일")) { self.viewModel.setOrderType(.date) },
                  .cancel(Text("취소")),
                ])
  }
}

struct MovieView_Previews: PreviewProvider {
  static var previews: some View {
    MovieView()
  }
}
