//
//  StarRatingBar.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/18.
//  Copyright © 2019 presto. All rights reserved.
//

import SwiftUI

struct StarRatingBar: View {

  @Binding var score: Double
  let length: CGFloat

  init(score: Binding<Double>, length: CGFloat = 20) {
    _score = score
    self.length = length
  }

  var body: some View {
    HStack(spacing: 0) {
      if score >= 2 {
        starImage(.full)
      } else if score > 1 {
        starImage(.half)
      } else {
        starImage(.normal)
      }

      if score >= 4 {
        starImage(.full)
      } else if score > 3 {
        starImage(.half)
      } else {
        starImage(.normal)
      }

      if score >= 6 {
        starImage(.full)
      } else if score > 5 {
        starImage(.half)
      } else {
        starImage(.normal)
      }

      if score >= 8 {
        starImage(.full)
      } else if score > 7 {
        starImage(.half)
      } else {
        starImage(.normal)
      }

      if score >= 10 {
        starImage(.full)
      } else if score > 9 {
        starImage(.half)
      } else {
        starImage(.normal)
      }
    }
  }

  func starImage(_ type: StarType) -> some View {
    Image(type.imageName)
      .resizable()
      .scaledToFit()
      .aspectRatio(1, contentMode: .fit)
      .frame(height: length)
  }
}

struct StarRatingBar_Previews: PreviewProvider {
  static var previews: some View {
    StarRatingBar(score: .constant(7.8), length: 20)
  }
}
