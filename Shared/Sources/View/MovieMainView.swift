//
//  MovieMainView.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/16.
//  Copyright © 2019 presto. All rights reserved.
//

import SwiftUI

struct MovieMainView: View {
  enum PresentationType {
    case list
    case grid
  }

  @ObservedObject private var viewModel: MovieMainViewModel
  
  init(viewModel: MovieMainViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    NavigationView {
      TabView(selection: $viewModel.presentationType) {
        movieListView

        movieGridView
      }
      .navigationTitle(Text("BoxOffice"))
      .navigationBarTitleDisplayMode(.automatic)
      .toolbar { ToolbarItem(placement: .navigationBarTrailing) { sortButton } }
      .actionSheet(isPresented: $viewModel.showsSortActionSheet) { sortActionSheet }
      .onAppear(perform: viewModel.setPresented)
    }
  }
}

// MARK: - View

private extension MovieMainView {
  var movieListView: some View {
    Group {
      if viewModel.isLoading {
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle())
      } else if viewModel.movieErrors.isEmpty == false {
        MovieRetryView(errors: viewModel.movieErrors, onRetry: viewModel.requestMovies)
      } else {
        MovieListView(movies: $viewModel.movies, sortMethod: $viewModel.sortMethod)
      }
    }
    .tabItem {
      Image(systemName: "list.dash")

      Text("List")
    }
    .tag(MovieMainView.PresentationType.list)
  }

  var movieGridView: some View {
    Group {
      if viewModel.isLoading {
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle())
      } else if viewModel.movieErrors.isEmpty == false {
        MovieRetryView(errors: viewModel.movieErrors, onRetry: viewModel.requestMovies)
      } else {
        MovieGridView(movies: $viewModel.movies, sortMethod: $viewModel.sortMethod)
      }
    }
    .tabItem {
      Image(systemName: "square.grid.2x2")
      
      Text("Grid")
    }
    .tag(MovieMainView.PresentationType.grid)
  }

  var sortButton: some View {
    Button(action: viewModel.setShowsSortActionSheet) {
      Text(viewModel.sortMethodDescription)
    }
  }

  var sortActionSheet: ActionSheet {
    ActionSheet(
      title: Text("정렬방식 선택"),
      message: Text("영화를 어떤 순서로 정렬할까요?"),
      buttons: [
        .default(Text("예매율")) { viewModel.setSortMethod(.reservation) },
        .default(Text("큐레이션")) { viewModel.setSortMethod(.curation) },
        .default(Text("개봉일")) { viewModel.setSortMethod(.date) },
        .cancel(Text("취소")),
      ])
  }
}

// MARK: - Preview

struct MovieView_Previews: PreviewProvider {
  static var previews: some View {
    MovieMainView(viewModel: MovieMainViewModel())
  }
}
