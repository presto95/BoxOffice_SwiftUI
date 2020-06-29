//
//  ActivityIndicator.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/18.
//  Copyright © 2019 presto. All rights reserved.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
  @Binding private var isAnimating: Bool
  private let style: UIActivityIndicatorView.Style

  init(isAnimating: Binding<Bool>, style: UIActivityIndicatorView.Style = .large) {
    _isAnimating = isAnimating
    self.style = style
  }

  func makeUIView(context _: Context) -> UIActivityIndicatorView {
    let view = UIActivityIndicatorView(style: style)
    view.hidesWhenStopped = true
    return view
  }

  func updateUIView(_ uiView: UIActivityIndicatorView, context _: Context) {
    isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
  }
}

struct ActivityIndicator_Previews: PreviewProvider {
  static var previews: some View {
    ActivityIndicator(isAnimating: .constant(true), style: .large)
  }
}
