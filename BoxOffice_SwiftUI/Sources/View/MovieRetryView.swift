//
//  MovieRetryView.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/23.
//  Copyright © 2019 presto. All rights reserved.
//

import SwiftUI

struct MovieRetryView: View {

  @Binding var errors: [MovieError]
  let onRetry: () -> Void

  var body: some View {
    VStack(spacing: 32) {
      VStack(spacing: 8) {
        Text("정보를 불러오지 못했습니다.")
          .font(.largeTitle)
          .minimumScaleFactor(0.9)

        VStack {
          ForEach(errors, id: \.self) { error in
            Text(error.localizedDescription)
              .font(.subheadline)
              .foregroundColor(.secondary)
          }
        }
      }

      Button("다시 시도하기", action: onRetry)
        .font(.title)
    }
    .padding()
  }
}

struct MovieRetryView_Previews: PreviewProvider {
  static var previews: some View {
    MovieRetryView(errors: .constant([]), onRetry: { })
  }
}
