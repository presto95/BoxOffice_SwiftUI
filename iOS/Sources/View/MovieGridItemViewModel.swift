//
//  MovieGridItemViewModel.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2020/06/29.
//  Copyright © 2020 presto. All rights reserved.
//

import Combine
import Foundation

final class MovieGridItemViewModel: ObservableObject {
    @Published private(set) var posterImageData: Data?
    @Published private(set) var gradeImageName: String = ""
    @Published private(set) var primaryText: String = ""
    @Published private(set) var secondaryText: String = ""
    @Published private(set) var tertiaryText: String = ""

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
            .assign(to: \.primaryText, on: self)
            .store(in: &cancellables)
        
        movieSharedPublisher
            .map { "\($0.reservationGrade)위(\($0.userRating)) / \($0.reservationRate)%" }
            .removeDuplicates()
            .assign(to: \.secondaryText, on: self)
            .store(in: &cancellables)
        
        movieSharedPublisher
            .map(\.date)
            .removeDuplicates()
            .assign(to: \.tertiaryText, on: self)
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
