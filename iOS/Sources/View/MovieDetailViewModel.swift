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

    @Published private(set) var data: (movieDetail: MovieDetailResponseModel, comments: [CommentsResponseModel.Comment])?
    @Published private(set) var posterImageData: Data?
    @Published private(set) var movieErrors: [APIError] = []

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

    private let showsCommentPostingSubject = CurrentValueSubject<Bool?, Never>(nil)
    private let movieIDSubject = CurrentValueSubject<String?, Never>(nil)
    private let dataSubject = CurrentValueSubject<(movieDetail: MovieDetailResponseModel, comments: CommentsResponseModel)?, Never>(nil)

    private var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    
    init(movieID: String, movieTitle: String) {
        self.title = movieTitle

        let apiService = DIContainer.shared.resolve(APIService.self)

        showsCommentPostingSubject
            .compactMap { $0 }
            .removeDuplicates()
            .assign(to: \.showsCommentPostingView, on: self)
            .store(in: &cancellables)

        let dataPublisher = dataSubject
            .compactMap { $0 }
            .share()

        let movieDetailPublisher = dataPublisher
            .map(\.movieDetail)

        dataPublisher
            .sink(receiveCompletion: { [weak self] completion in
                self?.movieErrors.append(.movieDetailRequestFailed)
            }, receiveValue: { [weak self] movieDetail, comments in
                self?.data = (movieDetail, comments.comments)
            })
            .store(in: &cancellables)

        movieDetailPublisher
            .map(\.imageURLString)
            .flatMap { imageURLString -> ImageDataPublisher in
                guard let apiService = apiService else {
                    return Empty().eraseToAnyPublisher()
                }
                return apiService.imageDataPublisher(fromURLString: imageURLString)
            }
            .replaceError(with: Data())
            .compactMap { $0 }
            .assign(to: \.posterImageData, on: self)
            .store(in: &cancellables)

        movieDetailPublisher
            .map(\.title)
            .removeDuplicates()
            .assign(to: \.title, on: self)
            .store(in: &cancellables)

        movieDetailPublisher
            .map(\.grade)
            .removeDuplicates()
            .compactMap(Grade.init)
            .map(\.imageName)
            .assign(to: \.gradeImageName, on: self)
            .store(in: &cancellables)

        movieDetailPublisher
            .map(\.date)
            .removeDuplicates()
            .map { "\($0) 개봉" }
            .assign(to: \.date, on: self)
            .store(in: &cancellables)

        movieDetailPublisher
            .map { (genre: $0.genre, duration: $0.duration) }
            .removeDuplicates { $0.genre == $1.genre && $0.duration == $1.duration }
            .map { "\($0) / \($1)분" }
            .assign(to: \.genreAndDuration, on: self)
            .store(in: &cancellables)

        movieDetailPublisher
            .map { (grade: $0.reservationGrade, rate: $0.reservationRate) }
            .removeDuplicates { $0.grade == $1.grade && $0.rate == $1.rate }
            .map { "\($0)위 \(String(format: "%.1f%%", $1))" }
            .assign(to: \.reservationMetric, on: self)
            .store(in: &cancellables)

        movieDetailPublisher
            .map(\.userRating)
            .removeDuplicates()
            .assign(to: \.userRating, on: self)
            .store(in: &cancellables)

        movieDetailPublisher
            .map(\.userRating)
            .removeDuplicates()
            .map { String(format: "%.2f", $0) }
            .assign(to: \.userRatingDescription, on: self)
            .store(in: &cancellables)

        movieDetailPublisher
            .map(\.audience)
            .removeDuplicates()
            .compactMap { NumberFormatter.decimal.string(from: $0 as NSNumber) }
            .assign(to: \.audience, on: self)
            .store(in: &cancellables)

        movieDetailPublisher
            .map(\.synopsis)
            .removeDuplicates()
            .assign(to: \.synopsis, on: self)
            .store(in: &cancellables)

        movieDetailPublisher
            .map(\.director)
            .removeDuplicates()
            .assign(to: \.director, on: self)
            .store(in: &cancellables)

        movieDetailPublisher
            .map(\.actor)
            .removeDuplicates()
            .assign(to: \.actor, on: self)
            .store(in: &cancellables)
        
        movieIDSubject.send(movieID)
    }
    
    // MARK: - Inputs

    func setShowsCommentPosting() {
        showsCommentPostingSubject.send(true)
    }
    
    func requestData() {
        guard isLoading == false else { return }
        
        movieErrors.removeAll()
        isLoading = true

        if let apiService = DIContainer.shared.resolve(APIService.self), let movieID = movieIDSubject.value {
            Publishers.Zip(apiService.movieDetailPublisher(withMovieID: movieID),
                           apiService.commentsPublisher(withMovieID: movieID))
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case let .failure(error):
                        self?.movieErrors.append(error)
                    case .finished:
                        break
                    }

                    self?.isLoading = false
                }, receiveValue: { [weak self] movieDetail, comments in
                    self?.dataSubject.send((movieDetail, comments))
                })
                .store(in: &cancellables)
        }
    }
}

// MARK: - Private Method

extension MovieDetailViewModel {
    func commentDateString(timestamp: Double) -> String {
        let formatter = DateFormatter.custom("yyyy-MM-dd HH:mm:ss")
        return formatter.string(from: Date(timeIntervalSince1970: timestamp))
    }
}
