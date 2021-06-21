//
//  MovieAPIError.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2021/06/21.
//  Copyright © 2021 presto. All rights reserved.
//

import Foundation

enum MovieAPIError: Error {
  case imageDataRequestFailed
  case moviesRequestFailed
  case movieDetailRequestFailed
  case commentsRequestFailed
  case commentPostingRequestFailed
}

extension MovieAPIError: LocalizedError {
  var localizedDescription: String {
    switch self {
    case .imageDataRequestFailed:
      return "이미지를 불러오지 못했습니다."
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
