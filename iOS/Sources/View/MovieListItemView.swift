//
//  MovieListItemView.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2020/06/29.
//  Copyright © 2020 presto. All rights reserved.
//

import SwiftUI

struct MovieListItemView: View {
    @ObservedObject private var viewModel: MovieListItemViewModel
    
    init(viewModel: MovieListItemViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack {
            PosterImage(data: viewModel.posterImageData)
                .aspectRatio(61 / 91, contentMode: .fit)
                .frame(height: UIScreen.main.bounds.height / 5)
                .cornerRadius(5)
            
            VStack(alignment: .leading) {
                Spacer()
                
                HStack(alignment: .center) {
                    Text(viewModel.title)
                        .titleStyle()
                    
                    Image(viewModel.gradeImageName)
                    
                    Spacer()
                }
                
                Spacer()

                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("평점")
                            .contentsStyle()
                            .foregroundColor(.init(.tertiaryLabel))

                        Text("예매순위")
                            .contentsStyle()
                            .foregroundColor(.init(.tertiaryLabel))

                        Text("예매율")
                            .contentsStyle()
                            .foregroundColor(.init(.tertiaryLabel))

                        Text("개봉일")
                            .contentsStyle()
                            .foregroundColor(.init(.tertiaryLabel))
                    }

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
                }
                
                Spacer()
            }
        }
    }
}

// MARK: - Preview

struct MovieListCell_Previews: PreviewProvider {
    static var previews: some View {
        MovieListItemView(viewModel: MovieListItemViewModel(movie: .dummy))
            .frame(maxHeight: UIScreen.main.bounds.height / 5)
    }
}
