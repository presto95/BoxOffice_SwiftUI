//
//  CommentPostingViewModel.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/16.
//  Copyright © 2019 presto. All rights reserved.
//

import Combine
import Foundation

final class CommentPostingViewModel: ObservableObject {
    @Published var nickname = ""
    @Published var comments = ""
    
    @Published private(set) var title: String = ""
    @Published private(set) var gradeImageName: String = ""
    @Published private(set) var rating: Double = 0
    @Published private(set) var ratingString: String = ""
    @Published private(set) var isPostingFinished: Bool = false

    private let movieSubject = CurrentValueSubject<MovieDetailResponseModel?, Never>(nil)
    private let ratingSubject = CurrentValueSubject<Double?, Never>(nil)

    private let apiService: MovieAPIServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(movie: MovieDetailResponseModel, apiService: MovieAPIServiceProtocol = MovieAPIService()) {
        self.apiService = apiService
        
        let movieSharedPublisher = movieSubject
            .compactMap { $0 }
            .share()
        
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
        
        let ratingSharedPublisher = ratingSubject
            .compactMap { $0 }
            .share()
        
        ratingSharedPublisher
            .map(Int.init)
            .map(String.init)
            .assign(to: \.ratingString, on: self)
            .store(in: &cancellables)
        
        ratingSharedPublisher
            .assign(to: \.rating, on: self)
            .store(in: &cancellables)
        
        movieSubject.send(movie)
        ratingSubject.send(0)
    }

    func setRating(_ rating: Double) {
        ratingSubject.send(rating)
    }
    
    func requestCommentPosting() {
        let comment = Comment(rating: Int(rating),
                              writer: nickname,
                              movieID: movieSubject.value?.id ?? "",
                              contents: comments)
        Just(comment)
            .flatMap(apiService.commentPostingPublisher(with:))
            .receive(on: DispatchQueue.main)
            .map { _ in true }
            .replaceError(with: true)
            .assign(to: \.isPostingFinished, on: self)
            .store(in: &cancellables)
    }
}
