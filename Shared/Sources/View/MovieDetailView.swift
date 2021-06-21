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
        MovieRetryView(errors: viewModel.movieErrors, onRetry: viewModel.requestData)
      } else {
        ScrollView {
          summarySection

          Divider()

          synopsisSection
//
          Divider()

          actorSection

          Divider()

          ratingSection
        }
      }
    }
    .navigationTitle(viewModel.title)
    .navigationBarTitleDisplayMode(.inline)
    .onReceive(viewModel.$showsCommentPosting) { showsCommentPosting in
      if showsCommentPosting == false {
        viewModel.requestData()
      }
    }
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
        .aspectRatio(61 / 91, contentMode: .fit)
        .frame(height: 170)
        .cornerRadius(5)

      VStack(alignment: .leading) {
        MultipleSpacer(count: 2)

        HStack(alignment: .center) {
          Text(viewModel.title)
            .titleStyle()

          Image(viewModel.gradeImageName)
        }

        Spacer()

        VStack(alignment: .leading, spacing: 4) {
          Text(viewModel.date)
            .contentsStyle()

          Text(viewModel.genreAndDuration)
            .contentsStyle()
        }

        MultipleSpacer(count: 2)
      }
      .frame(height: 170)

      Spacer()
    }
  }

  var summarySubSection: some View {
    HStack(alignment: .top) {
      Spacer()

      VStack(spacing: 8) {
        Text("예매율")
          .font(.headline)

        Text(viewModel.reservationMetric)
          .font(.footnote)
          .foregroundColor(.secondary)
      }

      Group {
        Spacer()

        Divider()

        Spacer()
      }

      VStack(spacing: 4) {
        Text("평점")
          .font(.headline)

        Text(viewModel.userRatingDescription)
          .font(.footnote)
          .foregroundColor(.secondary)

        StarRatingBar(score: viewModel.userRating)
      }

      Group {
        Spacer()

        Divider()

        Spacer()
      }

      VStack(spacing: 8) {
        Text("누적관객수")
          .font(.headline)

        Text(viewModel.audience)
          .font(.footnote)
          .foregroundColor(.secondary)
      }

      Spacer()
    }
  }
}

// MARK: - Section: Info

private extension MovieDetailView {
  var synopsisSection: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("줄거리")
        .font(.headline)

      Text(viewModel.synopsis)
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

        Text(viewModel.director)
          .font(.footnote)
          .fontWeight(.medium)
      }
      .padding(.leading, 4)

      HStack(alignment: .firstTextBaseline) {
        Text("출연")
          .font(.subheadline)
          .fontWeight(.semibold)

        Text(viewModel.actor)
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
          Image(systemName: "square.and.pencil")
            .accentColor(.orange)
        }
      }

      ratingContentsSection
    }
    .padding()
    .sheet(isPresented: $viewModel.showsCommentPosting) { 
      CommentPostingView(viewModel: CommentPostingViewModel(movie: viewModel.movie))
    }
  }

  var ratingContentsSection: some View {
    ForEach(viewModel.comments) { comment in
      HStack(alignment: .top) {
        Image(systemName: "person.circle")
          .resizable()
          .aspectRatio(1, contentMode: .fit)
          .frame(height: 50)

        VStack(alignment: .leading, spacing: 4) {
          VStack(alignment: .leading) {
            HStack {
              Text(comment.writer)
                .font(.subheadline)
                .fontWeight(.semibold)

              StarRatingBar(score: comment.rating, length: 15)
            }

            Text(viewModel.commentDateString(timestamp: comment.timestamp))
              .font(.footnote)
              .foregroundColor(.secondary)
          }

          Text(comment.contents)
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
