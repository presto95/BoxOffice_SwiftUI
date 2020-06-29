//
//  StarRatingBar.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/18.
//  Copyright © 2019 presto. All rights reserved.
//

import SwiftUI

struct StarRatingBar: View {
  private let score: Double
  private let length: CGFloat

  init(score: Double, length: CGFloat = 20) {
    self.score = score
    self.length = length
  }

  var body: some View {
    HStack(spacing: 0) {
      ForEach(1 ..< 6) { number in
        let reference = Double(number * 2)
        if score >= reference {
          starImage(of: .full)
        } else if score > reference - 1 {
          starImage(of: .half)
        } else {
          starImage(of: .normal)
        }
      }
    }
  }
}

private extension StarRatingBar {
  func starImage(of type: StarType) -> some View {
    Image(type.imageName)
      .resizable()
      .aspectRatio(1, contentMode: .fit)
      .frame(height: length)
  }
}

// MARK: - Preview

struct StarRatingBar_Previews: PreviewProvider {
  static var previews: some View {
    StarRatingBar(score: 7.8, length: 20)
  }
}
