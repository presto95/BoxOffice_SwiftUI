//
//  CommentPostingView.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/16.
//  Copyright © 2019 presto. All rights reserved.
//

import SwiftUI

struct CommentPostingView: View {
    @ObservedObject private var viewModel: CommentPostingViewModel
    @Binding private var isPresented: Bool
    
    init(viewModel: CommentPostingViewModel, isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        _isPresented = isPresented
    }
    
    var body: some View {
        NavigationView {
            VStack {
                starRatingSection
                
                Divider()
                    .padding(4)
                
                ratingFormSection
            }
            .navigationTitle("한줄평 작성")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    cancelButton
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    confirmButton
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .onReceive(viewModel.$isPostingFinished) { isPostingFinished in
                if isPostingFinished {
                    isPresented.toggle()
                }
            }
        }
    }
}

// MARK: - View

private extension CommentPostingView {
    var starRatingSection: some View {
        VStack {
            HStack {
                Text(viewModel.title)
                    .font(.headline)
                
                Image(viewModel.gradeImageName)
            }
            
            VStack {
                StarRatingBar(score: viewModel.rating, length: 40)
                    .gesture(starRatingBarDragGesture)
                
                Text(viewModel.ratingString)
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
        Button("취소") { isPresented.toggle() }
    }
    
    var confirmButton: some View {
        Button("완료") { viewModel.requestCommentPosting() }
    }
}

// MARK: - Preview

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        CommentPostingView(viewModel: CommentPostingViewModel(movie: .dummy), isPresented: .constant(false))
    }
}
