//
//  MovieDetailView.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/16.
//  Copyright © 2019 presto. All rights reserved.
//

import SwiftUI

struct MovieDetailView: View {
  @ObservedObject private var viewModel: MovieDetailViewModel

  init(viewModel: MovieDetailViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {
    Group {
      if viewModel.isLoading {
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle())
      } else if viewModel.movieErrors.isEmpty == false {
        MovieRetryView(errors: viewModel.movieErrors, onRetry: viewModel.retryMovieCommentsRequest)
      } else {
        ScrollView {
          summarySection

          Divider()

          synopsisSection

          Divider()

          actorSection

          Divider()

          ratingSection
        }
      }
    }
    .navigationBarTitle(viewModel.movieTitle)
    .onAppear(perform: viewModel.setPresented)
  }
}

// MARK: - Section: Summary

private extension MovieDetailView {
  var summarySection: some View {
    VStack(spacing: 20) {
      summaryMainSection

      summarySubSection
    }
    .padding()
  }

  var summaryMainSection: some View {
    HStack {
      PosterImage(data: viewModel.posterImageData)
        .aspectRatio(CGSize(width: 61, height: 81), contentMode: .fit)
        .frame(height: 170)
        .cornerRadius(5)
        .shadow(radius: 2)

      VStack(alignment: .leading) {
        MultipleSpacer(count: 2)

        HStack(alignment: .center) {
          Text(viewModel.movieTitle)
            .font(.title3)
            .fontWeight(.bold)
            .lineLimit(2)

          Image(viewModel.movieGradeImageName)
        }

        Spacer()

        VStack(alignment: .leading, spacing: 4) {
          Text(viewModel.movieDate)
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundColor(.secondary)
            .lineLimit(1)
            .minimumScaleFactor(0.5)

          Text(viewModel.movieGenreAndDuration)
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundColor(.secondary)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
        }

        MultipleSpacer(count: 2)
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

        Text(viewModel.movieReservationMetric)
          .font(.footnote)
          .foregroundColor(.secondary)
      }
      Divider()
        .padding(.horizontal, 8)

      VStack(spacing: 4) {
        Text("평점")
          .font(.headline)

        Text(viewModel.movieUserRatingString)
          .font(.footnote)
          .foregroundColor(.secondary)

        StarRatingBar(score: viewModel.movieUserRating)
      }

      Divider()
        .padding(.horizontal, 8)

      VStack(spacing: 8) {
        Text("누적관객수")
          .font(.headline)

        Text(viewModel.movieAudience)
          .font(.footnote)
          .foregroundColor(.secondary)
      }
    }
  }
}

// MARK: - Section: Info

private extension MovieDetailView {
  var synopsisSection: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("줄거리")
        .font(.headline)

      Text(viewModel.movieSynopsis)
        .font(.footnote)
        .fontWeight(.medium)
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
          .font(.subheadline)
          .fontWeight(.semibold)

        Text(viewModel.movieDirector)
          .font(.footnote)
          .fontWeight(.medium)
      }
      .padding(.leading, 4)

      HStack(alignment: .top) {
        Text("출연")
          .font(.subheadline)
          .fontWeight(.semibold)

        Text(viewModel.movieActor)
          .font(.footnote)
          .fontWeight(.medium)
      }
      .padding(.leading, 4)
    }
    .padding()
  }
}

// MARK: - Section: Rating

private extension MovieDetailView {
  var ratingSection: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Text("한줄평")
          .font(.headline)

        Spacer()

        Button(action: viewModel.setShowsCommentPosting) {
          Image("btn_compose")
            .renderingMode(.original)
        }
      }

      ratingContentsSection
    }
    .padding()
    .sheet(isPresented: $viewModel.showsCommentPosting) { 
      CommentsView(viewModel: CommentsViewModel(movie: viewModel.movie))
    }
  }

  var ratingContentsSection: some View {
    ForEach(viewModel.comments.indices) { index in
      HStack(alignment: .top) {
        Image("ic_user_loading")
          .resizable()
          .aspectRatio(1, contentMode: .fit)
          .frame(height: 50)

        VStack(alignment: .leading, spacing: 8) {
          VStack(alignment: .leading) {
            HStack {
              Text(viewModel.commentsWriter(at: index))
                .font(.subheadline)
                .fontWeight(.semibold)

              StarRatingBar(score: viewModel.commentsScore(at: index))
            }

            Text(viewModel.commentsDateString(at: index))
              .font(.footnote)
              .foregroundColor(.secondary)
          }

          Text(viewModel.commentsContents(at: index))
            .font(.footnote)
            .fontWeight(.medium)
        }
      }
      .padding(.vertical, 8)
    }
  }
}

// MARK: - Preview

struct MovieDetailView_Previews: PreviewProvider {
  static var previews: some View {
    MovieDetailView(viewModel: MovieDetailViewModel(movieID: ""))
  }
}
