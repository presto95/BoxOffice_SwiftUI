//
//  PosterImage.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2020/06/30.
//  Copyright © 2020 presto. All rights reserved.
//

#if os(iOS)
import UIKit
#else
import AppKit
#endif
import SwiftUI

struct PosterImage: View {
  private let data: Data?

  init(data: Data?) {
    self.data = data
  }

  var body: some View {
    #if os(iOS)
    if let data = data, let posterUIImage = UIImage(data: data) {
      return AnyView(
        Image(uiImage: posterUIImage)
          .resizable()
      )
    } else {
      return AnyView(placeholder)
    }
    #else
    if let data = data, let posterUIImage = NSImage(data: data) {
      return AnyView(
        Image(nsImage: posterUIImage)
          .resizable()
      )
    } else {
      return AnyView(placeholder)
    }
    #endif
  }
}

// MARK: - View

private extension PosterImage {
  var placeholder: some View {
    Image(systemName: "photo")
      .resizable()
      .aspectRatio(contentMode: .fit)
  }
}

// MARK: - Preview

struct PosterImage_Previews: PreviewProvider {
  static var previews: some View {
    PosterImage(data: nil)
  }
}
