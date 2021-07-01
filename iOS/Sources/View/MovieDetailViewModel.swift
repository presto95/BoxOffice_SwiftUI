//
//  MovieDetailViewModel.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/16.
//  Copyright © 2019 presto. All rights reserved.
//

import Combine
import Foundation

final class MovieDetailViewModel: ObservableObject {
    @Published var showsCommentPostingView = false

    @Published private(set) var isLoading = false
    @Published private(set) var movie: MovieDetailResponseModel = .dummy
    @Published private(set) var comments: [CommentsResponseModel.Comment] = []
    @Published private(set) var posterImageData: Data?
    @Published private(set) var movieErrors: [MovieAPIError] = []

    @Published private(set) var title: String = "-"
    @Published private(set) var gradeImageName: String = ""
    @Published private(set) var date: String = "-"
    @Published private(set) var genreAndDuration: String = "-"
    @Published private(set) var reservationMetric: String = "-"
    @Published private(set) var userRating: Double = 0
    @Published private(set) var userRatingDescription: String = "-"
    @Published private(set) var audience: String = "-"
    @Published private(set) var synopsis: String = "-"
    @Published private(set) var director: String = "-"
    @Published private(set) var actor: String = "-"

    private let isPresentedSubject = CurrentValueSubject<Void?, Never>(nil)
    private let isLoadingSubject = CurrentValueSubject<(Bool, Bool)?, Never>(nil)
    private let showsCommentPostingSubject = CurrentValueSubject<Bool?, Never>(nil)
    private let movieIDSubject = CurrentValueSubject<String?, Never>(nil)
    private let movieSubject = CurrentValueSubject<Result<MovieDetailResponseModel, Error>?, Never>(nil)
    private let commentsSubject = CurrentValueSubject<Result<[CommentsResponseModel.Comment], Error>?, Never>(nil)
    
    private let apiService: MovieAPIServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(movieID: String, movieTitle: String, apiService: MovieAPIServiceProtocol = MovieAPIService()) {
        self.apiService = apiService
        self.title = title
        
        isPresentedSubject
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] _ in
                self?.requestData()
            })
            .store(in: &cancellables)
        
        isLoadingSubject
            .compactMap { $0 }
            .map { $0 || $1 }
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
        
        showsCommentPostingSubject
            .compactMap { $0 }
            .assign(to: \.showsCommentPostingView, on: self)
            .store(in: &cancellables)
        
        let movieSharedPublisher = movieSubject
            .compactMap { $0 }
            .compactMap { try? $0.get() }
            .share()
        
        movieSharedPublisher
            .sink(receiveCompletion: { [weak self] completion in
                self?.movieErrors.append(.movieDetailRequestFailed)
            }, receiveValue: { [weak self] movieResponse in
                self?.movie = movieResponse
            })
            .store(in: &cancellables)
        
        movieSharedPublisher
            .map(\.imageURLString)
            .flatMap(apiService.imageDataPublisher(fromURLString:))
            .replaceError(with: Data())
            .compactMap { $0 }
            .assign(to: \.posterImageData, on: self)
            .store(in: &cancellables)
        
        movieSharedPublisher
            .map(\.title)
            .assign(to: \.title, on: self)
            .store(in: &cancellables)
        
        movieSharedPublisher
            .map(\.grade)
            .compactMap(Grade.init)
            .map(\.imageName)
            .assign(to: \.gradeImageName, on: self)
            .store(in: &cancellables)
        
        movieSharedPublisher
            .map(\.date)
            .map { "\($0) 개봉" }
            .assign(to: \.date, on: self)
            .store(in: &cancellables)
        
        movieSharedPublisher
            .map { ($0.genre, $0.duration) }
            .map { "\($0) / \($1)분" }
            .assign(to: \.genreAndDuration, on: self)
            .store(in: &cancellables)
        
        movieSharedPublisher
            .map { ($0.reservationGrade, $0.reservationRate) }
            .map { "\($0)위 \(String(format: "%.1f%%", $1))" }
            .assign(to: \.reservationMetric, on: self)
            .store(in: &cancellables)
        
        movieSharedPublisher
            .map(\.userRating)
            .assign(to: \.userRating, on: self)
            .store(in: &cancellables)
        
        movieSharedPublisher
            .map(\.userRating)
            .map { String(format: "%.2f", $0) }
            .assign(to: \.userRatingDescription, on: self)
            .store(in: &cancellables)
        
        movieSharedPublisher
            .map(\.audience)
            .compactMap { NumberFormatter.decimal.string(from: $0 as NSNumber) }
            .assign(to: \.audience, on: self)
            .store(in: &cancellables)
        
        movieSharedPublisher
            .map(\.synopsis)
            .assign(to: \.synopsis, on: self)
            .store(in: &cancellables)
        
        movieSharedPublisher
            .map(\.director)
            .assign(to: \.director, on: self)
            .store(in: &cancellables)
        
        movieSharedPublisher
            .map(\.actor)
            .assign(to: \.actor, on: self)
            .store(in: &cancellables)
        
        commentsSubject
            .compactMap { $0 }
            .tryMap { try $0.get() }
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure = completion {
                    self?.movieErrors.append(.commentsRequestFailed)
                }
            }, receiveValue: { [weak self] comments in
                self?.comments = comments
            })
            .store(in: &cancellables)
        
        movieIDSubject.send(movieID)
    }
    
    // MARK: - Inputs
    
    func setPresented() {
        isPresentedSubject.send(Void())
    }
    
    func setShowsCommentPosting() {
        showsCommentPostingSubject.send(true)
    }
    
    func requestData() {
        setLoading(true, to: .movie)
        setLoading(true, to: .comments)
        
        movieErrors.removeAll()
        
        movieIDSubject
            .compactMap { $0 }
            .first()
            .flatMap(apiService.movieDetailPublisher(withMovieID:))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case let .failure(error):
                    self?.movieSubject.send(.failure(error))
                case .finished:
                    break
                }

                self?.setLoading(false, to: .movie)
            }, receiveValue: { [weak self] movieResponse in
                self?.movieSubject.send(.success(movieResponse))
            })
            .store(in: &cancellables)
        
        movieIDSubject
            .compactMap { $0 }
            .first()
            .flatMap(apiService.commentsPublisher(withMovieID:))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case let .failure(error):
                    self?.commentsSubject.send(.failure(error))
                case .finished:
                    break
                }

                self?.setLoading(false, to: .comments)
            }, receiveValue: { [weak self] commentsResponse in
                self?.commentsSubject.send(.success(commentsResponse.comments))
            })
            .store(in: &cancellables)
    }
}

// MARK: - Private Method

extension MovieDetailViewModel {
    private enum RequestType {
        case movie
        case comments
    }

    private func setLoading(_ loading: Bool, to type: MovieDetailViewModel.RequestType) {
        var currentLoading = isLoadingSubject.value ?? (false, false)
        switch type {
        case .movie:
            currentLoading.0 = loading
        case .comments:
            currentLoading.1 = loading
        }
        isLoadingSubject.send(currentLoading)
    }
}

extension MovieDetailViewModel {
    func commentDateString(timestamp: Double) -> String {
        let formatter = DateFormatter.custom("yyyy-MM-dd HH:mm:ss")
        return formatter.string(from: Date(timeIntervalSince1970: timestamp))
    }
}
