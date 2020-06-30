//
//  MovieRetryView.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/23.
//  Copyright © 2019 presto. All rights reserved.
//

import SwiftUI

struct MovieRetryView: View {
  private let errors: [MovieError]
  private let onRetry: () -> Void

  init(errors: [MovieError], onRetry: @escaping () -> Void) {
    self.errors = errors
    self.onRetry = onRetry
  }

  var body: some View {
    VStack(spacing: 32) {
      VStack(spacing: 8) {
        Text("정보를 불러오지 못했습니다.")
          .font(.title3)
          .fontWeight(.bold)
          .lineLimit(1)

        VStack {
          ForEach(errors, id: \.self) { error in
            Text(error.localizedDescription)
              .font(.body)
              .foregroundColor(.secondary)
          }
        }
      }

      Button(action: onRetry) {
        Text("다시 시도하기")
          .font(.title3)
          .fontWeight(.semibold)
      }
      .padding()
    }
    .padding()
  }
}

// MARK: - Preview

struct MovieRetryView_Previews: PreviewProvider {
  static var previews: some View {
    MovieRetryView(errors: [.commentPostingRequestFailed], onRetry: {})
  }
}
