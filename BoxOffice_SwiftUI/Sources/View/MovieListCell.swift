//
//  MovieListCell.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2020/06/29.
//  Copyright © 2020 presto. All rights reserved.
//

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
      
      VStack(alignment: .leading) {
        Spacer()
        
        HStack(alignment: .center) {
          Text(viewModel.title)
            .titleStyle()
          
          Image(viewModel.gradeImageName)
          
          Spacer()
        }
        
        Spacer()

        VStack(alignment: .leading, spacing: 4) {
          Text(viewModel.rating)
            .contentsStyle()

          Text(viewModel.reservationGrade)
            .contentsStyle()

          Text(viewModel.reservationRate)
            .contentsStyle()

          Text(viewModel.date)
            .contentsStyle()
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
