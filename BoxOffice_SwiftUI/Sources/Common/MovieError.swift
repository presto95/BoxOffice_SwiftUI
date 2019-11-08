//
//  MovieError.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/22.
//  Copyright © 2019 presto. All rights reserved.
//

import Foundation

enum MovieError: Error {
  case movies

  case comments

  case movie

  case comment
}

extension MovieError: LocalizedError {
  var localizedDescription: String {
    switch self {
    case .movies:
      return "영화 정보를 불러오지 못했습니다."
    case .comments:
      return "한줄평 정보를 불러오지 못했습니다."
    case .movie:
      return "영화 상세 정보를 불러오지 못했습니다."
    case .comment:
      return "한줊평 등록에 실패했습니다."
    }
  }
}
