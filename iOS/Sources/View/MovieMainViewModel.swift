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
    
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var movieErrors: [MovieAPIError] = []
    @Published private(set) var sortMethodDescription: String = ""

    private let isPresentedSubject = CurrentValueSubject<Bool?, Never>(nil)
    private let showsSortActionSheetSubject = CurrentValueSubject<Bool?, Never>(nil)
    private let sortMethodSubject = CurrentValueSubject<SortMethod?, Never>(nil)

    private let apiService: MovieAPIServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(apiService: MovieAPIServiceProtocol = MovieAPIService()) {
        self.apiService = apiService
        
        isPresentedSubject
            .compactMap { $0 }
            .filter { $0 }
            .removeDuplicates()
            .map { _ in SortMethod.reservation }
            .sink(receiveValue: { [weak self] sortMethod in
                self?.sortMethodSubject.send(sortMethod)
            })
            .store(in: &cancellables)
        
        sortMethodSubject
            .compactMap { $0 }
            .removeDuplicates()
            .sink(receiveValue: { [weak self] sortMethod in
                self?.sortMethod = sortMethod
                self?.sortMethodDescription = sortMethod.description
                self?.requestMovies()
            })
            .store(in: &cancellables)
        
        showsSortActionSheetSubject
            .compactMap { $0 }
            .assign(to: \.showsSortActionSheet, on: self)
            .store(in: &cancellables)
    }

    func setPresented() {
        isPresentedSubject.send(true)
    }
    
    func setSortMethod(_ sortMethod: SortMethod) {
        sortMethodSubject.send(sortMethod)
    }
    
    func setShowsSortActionSheet() {
        showsSortActionSheetSubject.send(true)
    }
    
    func requestMovies() {
        movieErrors.removeAll()
        isLoading = true
        
        apiService.moviesPublisher(with: sortMethod)
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
