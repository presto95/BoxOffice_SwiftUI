//
//  CommentsView.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/16.
//  Copyright © 2019 presto. All rights reserved.
//

import SwiftUI

struct CommentsView: View {
  @Environment(\.presentationMode) private var presentationMode
  @ObservedObject private var viewModel: CommentsViewModel

  init(viewModel: CommentsViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {
    NavigationView {
      VStack {
        starRatingSection

        Divider()
          .padding(4)

        ratingFormSection
      }
      .navigationBarTitle(Text("한줄평 작성"), displayMode: .inline)
      .navigationBarItems(leading: cancelButton, trailing: confirmButton)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .padding()
    }
  }
}

// MARK: - View

private extension CommentsView {
  var starRatingSection: some View {
    VStack {
      HStack {
        Text(viewModel.movieTitle)
          .font(.headline)

        Image(viewModel.movieGradeImageName)
      }

      VStack {
        StarRatingBar(score: viewModel.rating, length: 40)
          .gesture(starRatingBarDragGesture)

        Text(viewModel.movieRatingString)
          .font(.headline)
      }
    }
  }

  var ratingFormSection: some View {
    VStack {
      TextField("닉네임", text: $viewModel.nickname)
        .textFieldStyle(RoundedBorderTextFieldStyle())

      TextField("한줄평을 작성해주세요", text: $viewModel.comments)
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .lineLimit(nil)
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
    .frame(maxHeight: .infinity)
  }

  var starRatingBarDragGesture: some Gesture {
    DragGesture()
      .onChanged { value in
        let x = max(0, min(value.location.x, 40 * 5))
        viewModel.setRating(Double(x / 20))
      }
  }

  var cancelButton: some View {
    Button("취소") { presentationMode.wrappedValue.dismiss() }
  }

  var confirmButton: some View {
    Button("완료") { viewModel.requestCommentPosting() }
  }
}

// MARK: - Preview

struct CommentsView_Previews: PreviewProvider {
  static var previews: some View {
    CommentsView(viewModel: CommentsViewModel(movie: .dummy))
  }
}
