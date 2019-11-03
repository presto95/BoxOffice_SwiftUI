//
//  CommentsView.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/16.
//  Copyright © 2019 presto. All rights reserved.
//

import SwiftUI

struct CommentsView: View {

  @Environment(\.presentationMode) var presentationMode
  @ObservedObject var viewModel: CommentsViewModel

  init(movie: MovieResponse) {
    viewModel = CommentsViewModel(movie: movie)
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

extension CommentsView {

  var starRatingSection: some View {
    VStack(alignment: .leading) {
      HStack {
        Text(viewModel.movieTitle)
          .font(.headline)

        Image(viewModel.movieGradeImageName)
      }

      VStack {
        StarRatingBar(score: $viewModel.rating, length: 40)
          .gesture(starRatingBarDragGesture)

        Text(viewModel.movieRatingString)
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
        self.viewModel.setRating(Double(value.location.x / 20))
    }
  }

  var cancelButton: some View {
    Button(action: {
      self.presentationMode.wrappedValue.dismiss()
    }, label: {
      Text("취소")
        .foregroundColor(.primary)
    })
  }

  var confirmButton: some View {
    Button(action: {
      self.viewModel.postComment()
    }, label: {
      Text("완료")
        .foregroundColor(.primary)
    })
  }
}

struct CommentsView_Previews: PreviewProvider {
  static var previews: some View {
    CommentsView(movie: .dummy)
  }
}
