//
//  MovieListCellModel.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2020/06/29.
//  Copyright © 2020 presto. All rights reserved.
//

import Combine
import Foundation

final class MovieListCellModel: ObservableObject {
    @Published private(set) var posterImageData: Data?
    @Published private(set) var gradeImageName: String = ""
    @Published private(set) var title: String = ""
    @Published private(set) var rating: String = ""
    @Published private(set) var reservationGrade: String = ""
    @Published private(set) var reservationRate: String = ""
    @Published private(set) var date: String = ""

    private let movieSubject = CurrentValueSubject<MoviesResponseModel.Movie?, Never>(nil)

    private let apiService: MovieAPIServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(movie: MoviesResponseModel.Movie,
         apiService: MovieAPIServiceProtocol = MovieAPIService()) {
        self.apiService = apiService
        
        let movieSharedPublisher = movieSubject
            .compactMap { $0 }
            .share()
        
        movieSharedPublisher
            .map(\.grade)
            .compactMap(Grade.init)
            .map(\.imageName)
            .assign(to: \.gradeImageName, on: self)
            .store(in: &cancellables)
        
        movieSharedPublisher
            .map(\.title)
            .assign(to: \.title, on: self)
            .store(in: &cancellables)
        
        movieSharedPublisher
            .map(\.userRating)
            .map { "평점\t\t\t\($0)" }
            .assign(to: \.rating, on: self)
            .store(in: &cancellables)
        
        movieSharedPublisher
            .map(\.reservationGrade)
            .map { "예매순위\t\t\($0)" }
            .assign(to: \.reservationGrade, on: self)
            .store(in: &cancellables)
        
        movieSharedPublisher
            .map(\.reservationRate)
            .map { "예매율\t\t\($0)%" }
            .assign(to: \.reservationRate, on: self)
            .store(in: &cancellables)
        
        movieSharedPublisher
            .map(\.date)
            .map { "개봉일\t\t\($0)" }
            .assign(to: \.date, on: self)
            .store(in: &cancellables)
        
        movieSharedPublisher
            .map(\.thumb)
            .flatMap(apiService.imageDataPublisher(fromURLString:))
            .replaceError(with: Data())
            .compactMap { $0 }
            .assign(to: \.posterImageData, on: self)
            .store(in: &cancellables)
        
        movieSubject.send(movie)
    }
}
