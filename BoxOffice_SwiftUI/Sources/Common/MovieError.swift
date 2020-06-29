//
//  MovieError.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/22.
//  Copyright © 2019 presto. All rights reserved.
//

import Foundation

enum MovieError: Error {
  case moviesRequestFailed
  case commentsRequestFailed
  case movieDetailRequestFailed
  case commentPostingRequestFailed
}

extension MovieError: LocalizedError {
  var localizedDescription: String {
    switch self {
    case .moviesRequestFailed:
      return "영화 정보를 불러오지 못했습니다."
    case .commentsRequestFailed:
      return "한줄평 정보를 불러오지 못했습니다."
    case .movieDetailRequestFailed:
      return "영화 상세 정보를 불러오지 못했습니다."
    case .commentPostingRequestFailed:
      return "한줄평 등록에 실패했습니다."
    }
  }
}
