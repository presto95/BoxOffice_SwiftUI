//
//  MovieUICollectionViewCell.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/17.
//  Copyright © 2019 presto. All rights reserved.
//

import Combine
import UIKit

final class MovieUICollectionViewCell: UICollectionViewCell {

  @IBOutlet private weak var posterImageView: UIImageView!

  @IBOutlet private weak var gradeImageView: UIImageView!

  @IBOutlet private weak var primaryLabel: UILabel!

  @IBOutlet private weak var secondaryLabel: UILabel!

  @IBOutlet private weak var tertiaryLabel: UILabel!

  private var cancellables = Set<AnyCancellable>()

  override func awakeFromNib() {
    posterImageView.image = UIImage(named: "image_placeholder")

    primaryLabel.minimumScaleFactor = 0.5
    primaryLabel.adjustsFontSizeToFitWidth = true

    secondaryLabel.minimumScaleFactor = 0.5
    secondaryLabel.adjustsFontSizeToFitWidth = true
    
    tertiaryLabel.minimumScaleFactor = 0.5
    tertiaryLabel.adjustsFontSizeToFitWidth = true
  }

  override func prepareForReuse() {
    posterImageView.image = UIImage(named: "img_placeholder")
    gradeImageView.image = nil
    primaryLabel.text = nil
    secondaryLabel.text = nil
    tertiaryLabel.text = nil
  }

  func configure(with movie: MoviesResponse.Movie) {
    if let imageData = ImageCache.fetch(forKey: movie.thumb) {
      posterImageView.image = UIImage(data: imageData)
    } else {
      Just(movie.thumb)
        .compactMap { URL(string: $0) }
        .receive(on: DispatchQueue.global())
        .tryMap { try Data(contentsOf: $0) }
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { completion in
          if case .failure = completion {
            self.posterImageView.image = UIImage(named: "img_placeholder")
          }
        }, receiveValue: { imageData in
          ImageCache.add(imageData, forKey: movie.thumb)
          self.posterImageView.image = UIImage(data: imageData)
        })
        .store(in: &cancellables)
    }

    let grade = Grade(rawValue: movie.grade) ?? .allAges
    gradeImageView.image = UIImage(named: grade.imageName)

    primaryLabel.text = movie.title
    primaryLabel.textColor = .label
    primaryLabel.font = .preferredFont(forTextStyle: .title2)

    secondaryLabel.text = """
    \(movie.reservationGrade)위(\(movie.userRating)) / \(movie.reservationRate)%
    """
    secondaryLabel.textColor = .secondaryLabel
    secondaryLabel.font = .preferredFont(forTextStyle: .body)
    
    tertiaryLabel.text = movie.date
    tertiaryLabel.textColor = .secondaryLabel
    tertiaryLabel.font = .preferredFont(forTextStyle: .body)
  }
}
