//
//  PosterImage.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2020/06/30.
//  Copyright © 2020 presto. All rights reserved.
//

import SwiftUI

struct PosterImage: View {
  private let data: Data?

  init(data: Data?) {
    self.data = data
  }

  var body: some View {
    if let data = data {
      let posterUIImage = UIImage(data: data)
      if let posterUIImage = posterUIImage {
        return Image(uiImage: posterUIImage)
          .resizable()
      } else {
        return placeholder
      }
    } else {
      return placeholder
    }
  }
}

// MARK: - View

private extension PosterImage {
  var placeholder: Image {
    Image("img_placeholder")
      .resizable()
  }
}

// MARK: - Preview

struct PosterImage_Previews: PreviewProvider {
  static var previews: some View {
    PosterImage(data: nil)
  }
}
