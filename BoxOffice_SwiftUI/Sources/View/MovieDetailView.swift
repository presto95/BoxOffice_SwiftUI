//
//  MovieDetailView.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/16.
//  Copyright © 2019 presto. All rights reserved.
//

import SwiftUI

struct MovieDetailView: View {

  @ObservedObject var viewModel: MovieDetailViewModel

  init(movieID: String) {
    viewModel = MovieDetailViewModel(movieID: movieID)
  }

  var body: some View {
    Group {
      if viewModel.isLoading {
        ActivityIndicator(animating: $viewModel.isLoading)
      } else if !viewModel.movieErrors.isEmpty {
        MovieRetryView(errors: $viewModel.movieErrors) {
          self.viewModel.requestData()
        }
      } else {
        ScrollView {
          summarySection

          Divider()
            .padding(4)

          synopsisSection

          Divider()
            .padding(4)

          actorSection

          Divider()
            .padding(4)

          ratingSection
        }
      }
    }
    .navigationBarTitle(viewModel.movie.title)
    .onAppear { self.viewModel.setPresented() }
  }

  var summarySection: some View {
    VStack {
      summaryMainSection

      summarySubSection
    }
    .padding()
  }

  var summaryMainSection: some View {
    HStack {
      Image(uiImage: UIImage(data: viewModel.posterImageData) ?? #imageLiteral(resourceName: "img_placeholder"))
        .resizable()
        .scaledToFit()
        .aspectRatio(CGSize(width: 61, height: 81), contentMode: .fit)
        .frame(height: 170)

      VStack(alignment: .leading) {
        MultipleSpacer(2)

        HStack {
          Text(viewModel.movie.title)
            .font(.title)

          Image((Grade(rawValue: viewModel.movie.grade) ?? .allAges).imageName)
        }

        Spacer()

        Text("\(viewModel.movie.date) 개봉")
          .foregroundColor(.secondary)

        Spacer()

        Text("\(viewModel.movie.genre) / \(viewModel.movie.duration)분")
          .foregroundColor(.secondary)

        MultipleSpacer(2)
      }
      .frame(height: 170)

      Spacer()
    }
  }

  var summarySubSection: some View {
    HStack {
      VStack(spacing: 8) {
        Text("예매율")
          .font(.headline)

        Text("\(viewModel.movie.reservationGrade)위 \(viewModel.movie.reservationRate, specifier: "%.1f%%")")
          .foregroundColor(.secondary)
      }

      Divider()
        .padding(.horizontal, 8)

      VStack(spacing: 8) {
        Text("평점")
          .font(.headline)

        Text("\(viewModel.movie.userRating, specifier: "%.2f")")
          .foregroundColor(.secondary)

        StarRatingBar(score: .constant(viewModel.movie.userRating))
      }

      Divider()
        .padding(.horizontal, 8)

      VStack(spacing: 8) {
        Text("누적관객수")
          .font(.headline)

        Text("\(viewModel.movie.audience)")
          .foregroundColor(.secondary)
      }
    }
    .frame(height: 60)

  }

  var synopsisSection: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("줄거리")
        .font(.headline)

      Text(viewModel.movie.synopsis)
        .padding(.leading, 4)
    }
    .padding()
  }

  var actorSection: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("감독/출연")
        .font(.headline)

      HStack {
        Text("감독")
          .font(.headline)

        Text(viewModel.movie.director)
      }
      .padding(.leading, 4)

      HStack(alignment: .top) {
        Text("출연")
          .font(.headline)

        Text(viewModel.movie.actor)
      }
      .padding(.leading, 4)
    }
    .padding()
  }

  var ratingSection: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Text("한줄평")
          .font(.headline)

        Spacer()

        Button(action: {
          self.viewModel.setShowsCommentPosting()
        }, label: {
          Image("btn_compose")
            .renderingMode(.original)
        })
      }

      ratingContentsSection
    }
    .padding()
    .sheet(isPresented: $viewModel.showsCommentPosting) {
      CommentsView(movie: self.viewModel.movie)
    }
  }

  var ratingContentsSection: some View {
    ForEach(viewModel.comments) { comments in
      HStack {
        Image("ic_user_loading")
          .resizable()
          .aspectRatio(1, contentMode: .fit)
          .frame(height: 70)

        VStack(alignment: .leading) {
          HStack {
            Text(comments.writer)

            StarRatingBar(score: .constant(Double(comments.rating)))
          }

          Text(comments.dateString(formatter: .custom("yyyy-MM-dd HH:mm:ss")))

          Spacer()

          Text(comments.contents)
        }
      }
      .padding(.vertical, 8)
    }
  }

  func errorAlert(_ error: MovieError) -> Alert {
    Alert(title: Text("오류"),
          message: Text(error.localizedDescription),
          dismissButton: .default(Text("확인")))
  }
}

struct MovieDetailView_Previews: PreviewProvider {
  static var previews: some View {
    MovieDetailView(movieID: "")
  }
}
