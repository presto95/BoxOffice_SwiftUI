//
//  MovieListCell.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2020/06/29.
//  Copyright © 2020 presto. All rights reserved.
//

import Foundation
import SwiftUI

struct MovieListCell: View {
  @ObservedObject private var viewModel: MovieListCellModel
  
  init(viewModel: MovieListCellModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    HStack {
      PosterImage(data: viewModel.posterImageData)
        .aspectRatio(61 / 91, contentMode: .fit)
        .frame(height: UIScreen.main.bounds.height / 5)
        .cornerRadius(5)
        .shadow(radius: 2)
      
      VStack {
        Spacer()
        
        HStack(alignment: .center) {
          Text(viewModel.primaryText)
            .font(.title3)
            .fontWeight(.bold)
            .lineLimit(2)
          
          Image(viewModel.gradeImageName)
          
          Spacer()
        }
        
        Spacer()

        VStack(spacing: 4) {
          HStack {
            Text(viewModel.secondaryText)
              .font(.subheadline)
              .fontWeight(.medium)
              .foregroundColor(.secondary)
              .lineLimit(1)
              .minimumScaleFactor(0.5)

            Spacer()
          }

          HStack {
            Text(viewModel.tertiaryText)
              .font(.subheadline)
              .fontWeight(.medium)
              .foregroundColor(.secondary)
              .lineLimit(1)

            Spacer()
          }
        }

        Spacer()
      }
      .padding(.trailing, 20)
    }
  }
}

// MARK: - Preview

struct MovieListCell_Previews: PreviewProvider {
  static var previews: some View {
    MovieListCell(viewModel: MovieListCellModel(movie: .dummy))
      .frame(maxHeight: UIScreen.main.bounds.height / 5)
  }
}
