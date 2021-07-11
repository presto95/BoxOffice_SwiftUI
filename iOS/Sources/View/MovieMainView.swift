//
//  MovieMainView.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/16.
//  Copyright © 2019 presto. All rights reserved.
//

import SwiftUI

struct MovieMainView: View {
    @ObservedObject private var viewModel: MovieMainViewModel

    init(viewModel: MovieMainViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        TabView(selection: $viewModel.currentTab) {
            NavigationView {
                movieListView
                    .movieMainViewNavigationBarStyle()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            sortButton
                        }
                    }
            }
            .tabItem {
                Label("List", systemImage: "list.dash")
            }
            .tag(MovieMainView.Tab.list)

            NavigationView {
                movieGridView
                    .movieMainViewNavigationBarStyle()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            sortButton
                        }
                    }
            }
            .tabItem {
                Label("Grid", systemImage: "square.grid.2x2")
            }
            .tag(MovieMainView.Tab.grid)
        }
        .actionSheet(isPresented: $viewModel.showsSortActionSheet) {
            sortActionSheet
        }
        .onAppear(perform: viewModel.setPresented)
    }
}

// MARK: - View

private extension MovieMainView {
    @ViewBuilder var movieListView: some View {
        if viewModel.isLoading {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        } else if viewModel.movieErrors.isEmpty == false {
            MovieRetryView(errors: viewModel.movieErrors, onRetry: viewModel.requestMovies)
        } else {
            MovieListView(movies: $viewModel.movies, sortMethod: $viewModel.sortMethod)
        }
    }

    @ViewBuilder var movieGridView: some View {
        if viewModel.isLoading {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        } else if viewModel.movieErrors.isEmpty == false {
            MovieRetryView(errors: viewModel.movieErrors, onRetry: viewModel.requestMovies)
        } else {
            MovieGridView(movies: $viewModel.movies, sortMethod: $viewModel.sortMethod)
        }
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
                .default(Text("예매율")) {
                    viewModel.setSortMethod(.reservation)
                },
                .default(Text("큐레이션")) {
                    viewModel.setSortMethod(.curation)
                },
                .default(Text("개봉일")) {
                    viewModel.setSortMethod(.date)
                },
                .cancel(Text("취소")),
            ]
        )
    }
}

extension MovieMainView {
    enum Tab {
        case list
        case grid
    }
}

// MARK: - Preview

struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieMainView(viewModel: MovieMainViewModel())
    }
}
