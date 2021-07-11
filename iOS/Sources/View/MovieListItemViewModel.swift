//
//  MovieListItemViewModel.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2020/06/29.
//  Copyright © 2020 presto. All rights reserved.
//

import Combine
import Foundation

final class MovieListItemViewModel: ObservableObject {
    @Published private(set) var posterImageData: Data?
    @Published private(set) var gradeImageName: String = ""
    @Published private(set) var title: String = ""
    @Published private(set) var rating: String = ""
    @Published private(set) var reservationGrade: String = ""
    @Published private(set) var reservationRate: String = ""
    @Published private(set) var date: String = ""

    private let movieSubject = CurrentValueSubject<MoviesResponseModel.Movie?, Never>(nil)

    private var cancellables = Set<AnyCancellable>()
    
    init(movie: MoviesResponseModel.Movie) {
        let apiService = DIContainer.shared.resolve(APIService.self)
        let movieSharedPublisher = movieSubject
            .compactMap { $0 }
            .share()
        
        movieSharedPublisher
            .map(\.grade)
            .removeDuplicates()
            .compactMap(Grade.init)
            .map(\.imageName)
            .assign(to: \.gradeImageName, on: self)
            .store(in: &cancellables)
        
        movieSharedPublisher
            .map(\.title)
            .removeDuplicates()
            .assign(to: \.title, on: self)
            .store(in: &cancellables)
        
        movieSharedPublisher
            .map(\.userRating)
            .removeDuplicates()
            .map { String($0) }
            .assign(to: \.rating, on: self)
            .store(in: &cancellables)
        
        movieSharedPublisher
            .map(\.reservationGrade)
            .removeDuplicates()
            .map(String.init)
            .assign(to: \.reservationGrade, on: self)
            .store(in: &cancellables)
        
        movieSharedPublisher
            .map(\.reservationRate)
            .removeDuplicates()
            .map { "\($0)%" }
            .assign(to: \.reservationRate, on: self)
            .store(in: &cancellables)
        
        movieSharedPublisher
            .map(\.date)
            .removeDuplicates()
            .assign(to: \.date, on: self)
            .store(in: &cancellables)
        
        movieSharedPublisher
            .map(\.thumb)
            .removeDuplicates()
            .flatMap { thumb -> ImageDataPublisher in
                guard let apiService = apiService else {
                    return Empty().eraseToAnyPublisher()
                }
                return apiService.imageDataPublisher(fromURLString: thumb)
                    .eraseToAnyPublisher()
            }
            .replaceError(with: Data())
            .compactMap { $0 }
            .assign(to: \.posterImageData, on: self)
            .store(in: &cancellables)
        
        movieSubject.send(movie)
    }
}
