//
//  MultipleSpacer.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/23.
//  Copyright © 2019 presto. All rights reserved.
//

import SwiftUI

struct MultipleSpacer: View {
  private let count: Int
  private let minLength: CGFloat?

  init(count: Int = 1, minLength: CGFloat? = nil) {
    self.count = max(1, count)
    self.minLength = minLength
  }

  var body: some View {
    ForEach(0 ..< count) { _ in
      Spacer(minLength: self.minLength)
    }
  }
}

// MARK: - Preview

struct MultipleSpacer_Previews: PreviewProvider {
  static var previews: some View {
    MultipleSpacer()
  }
}
