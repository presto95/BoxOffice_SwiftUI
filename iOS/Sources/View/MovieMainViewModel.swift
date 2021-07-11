//
//  MovieMainViewModel.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/16.
//  Copyright © 2019 presto. All rights reserved.
//

import Combine
import Foundation

final class MovieMainViewModel: ObservableObject {
    @Published var currentTab: MovieMainView.Tab = .list
    @Published var showsSortActionSheet: Bool = false
    @Published var sortMethod: SortMethod = .reservation
    @Published var movies: [MoviesResponseModel.Movie] = []

    @Published private(set) var movieErrors: [APIError] = []
    @Published private(set) var sortMethodDescription: String = ""

    private let showsSortActionSheetSubject = CurrentValueSubject<Bool?, Never>(nil)
    private let sortMethodSubject = CurrentValueSubject<SortMethod?, Never>(nil)

    private var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        sortMethodSubject
            .compactMap { $0 }
            .removeDuplicates()
            .sink(receiveValue: { [weak self] sortMethod in
                self?.sortMethod = sortMethod
                self?.sortMethodDescription = sortMethod.description
                self?.requestData()
            })
            .store(in: &cancellables)
        
        showsSortActionSheetSubject
            .compactMap { $0 }
            .removeDuplicates()
            .assign(to: \.showsSortActionSheet, on: self)
            .store(in: &cancellables)
    }
    
    func setSortMethod(_ sortMethod: SortMethod) {
        sortMethodSubject.send(sortMethod)
    }
    
    func setShowsSortActionSheet() {
        showsSortActionSheetSubject.send(true)
    }
    
    func requestData() {
        movieErrors.removeAll()
        isLoading = true

        let apiService = DIContainer.shared.resolve(APIService.self)
        apiService?.moviesPublisher(with: sortMethod)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case let .failure(error):
                    self?.movieErrors.append(error)
                case .finished:
                    break
                }
                
                self?.isLoading = false
            }, receiveValue: { [weak self] moviesResponse in
                self?.movies = moviesResponse.movies
            })
            .store(in: &cancellables)
    }
}
