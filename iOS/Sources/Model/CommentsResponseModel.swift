//
//  CommentsResponse.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/16.
//  Copyright © 2019 presto. All rights reserved.
//

struct CommentsResponseModel: Decodable, Identifiable {
    struct Comment: Decodable, Identifiable {
        let movieID: String
        let contents: String
        let timestamp: Double
        let id: String
        let writer: String
        let rating: Double
        
        private enum CodingKeys: String, CodingKey {
            case movieID = "movie_id"
            case contents
            case timestamp
            case id
            case writer
            case rating
        }
    }
    
    var id: String { movieID }
    let comments: [Comment]
    let movieID: String
    
    private enum CodingKeys: String, CodingKey {
        case comments
        case movieID = "movie_id"
    }
}

extension CommentsResponseModel {
    static let dummy = CommentsResponseModel(comments: [.dummy], movieID: "1")
}

extension CommentsResponseModel.Comment {
    static let dummy = CommentsResponseModel.Comment(movieID: "1",
                                                     contents: "컨텐츠",
                                                     timestamp: 0,
                                                     id: "1",
                                                     writer: "Presto",
                                                     rating: 8.4)
}
