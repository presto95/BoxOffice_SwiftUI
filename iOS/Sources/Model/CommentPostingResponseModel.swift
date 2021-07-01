//
//  CommentResponse.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/18.
//  Copyright © 2019 presto. All rights reserved.
//

struct CommentPostingResponseModel: Decodable {
    let rating: Int
    let timestamp: Double
    let writer: String
    let movieID: String
    let contents: String
    
    private enum CodingKeys: String, CodingKey {
        case rating
        case timestamp
        case writer
        case movieID = "movie_id"
        case contents
    }
}

extension CommentPostingResponseModel {
    static let dummy = CommentPostingResponseModel(rating: 0,
                                                   timestamp: 0,
                                                   writer: "Presto",
                                                   movieID: "1",
                                                   contents: "contents")
}
