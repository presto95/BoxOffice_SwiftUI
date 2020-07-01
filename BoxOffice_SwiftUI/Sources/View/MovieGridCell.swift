//
//  MovieGridCell.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2020/06/29.
//  Copyright © 2020 presto. All rights reserved.
//

import SwiftUI

struct MovieGridCell: View {
  @ObservedObject private var viewModel: MovieGridCellModel
  
  init(viewModel: MovieGridCellModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    VStack {
      ZStack(alignment: .topTrailing) {
        PosterImage(data: viewModel.posterImageData)
          .aspectRatio(61 / 91, contentMode: .fit)
          .cornerRadius(5)
          .shadow(radius: 2)
        
        Image(viewModel.gradeImageName)
          .padding(.top, 8)
          .padding(.trailing, 8)
      }
      .padding(.top, 8)
      .padding(.horizontal, 10)

      VStack(spacing: 4) {
        Text(viewModel.primaryText)
          .titleStyle()
          .multilineTextAlignment(.center)

        Text(viewModel.secondaryText)
          .contentsStyle()

        Text(viewModel.tertiaryText)
          .contentsStyle()
      }
      .padding(.bottom, 4)
    }
  }
}

// MARK: - Preview

struct MovieGridCell_Previews: PreviewProvider {
  static var previews: some View {
    MovieGridCell(viewModel: MovieGridCellModel(movie: .dummy))
      .frame(maxWidth: UIScreen.main.bounds.width / 2)
  }
}
