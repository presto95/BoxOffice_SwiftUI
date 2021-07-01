//
//  MovieGridCellModel.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2020/06/29.
//  Copyright © 2020 presto. All rights reserved.
//

import Combine
import Foundation

final class MovieGridCellModel: ObservableObject {
    @Published private(set) var posterImageData: Data?
    @Published private(set) var gradeImageName: String = ""
    @Published private(set) var primaryText: String = ""
    @Published private(set) var secondaryText: String = ""
    @Published private(set) var tertiaryText: String = ""

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
            .assign(to: \.primaryText, on: self)
            .store(in: &cancellables)
        
        movieSharedPublisher
            .map { "\($0.reservationGrade)위(\($0.userRating)) / \($0.reservationRate)%" }
            .assign(to: \.secondaryText, on: self)
            .store(in: &cancellables)
        
        movieSharedPublisher
            .map(\.date)
            .assign(to: \.tertiaryText, on: self)
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
