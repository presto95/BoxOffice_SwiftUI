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
  let style: UIActivityIndicatorView.Style

  init(animating: Binding<Bool>, style: UIActivityIndicatorView.Style = .large) {
    self.style = style
    _isAnimating = animating
  }

  func makeUIView(context: Context) -> UIActivityIndicatorView {
    let view = UIActivityIndicatorView(style: style)
    view.hidesWhenStopped = true
    return view
  }

  func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
    isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
  }
}

struct ActivityIndicator_Previews: PreviewProvider {
  static var previews: some View {
    ActivityIndicator(animating: .constant(false), style: .large)
  }
}
