//
//  MovieTableViewCell.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/17.
//  Copyright © 2019 presto. All rights reserved.
//

import Combine
import UIKit

final class MovieUITableViewCell: UITableViewCell, NetworkImageFetchable {
  @IBOutlet private var posterImageView: UIImageView!
  @IBOutlet private var gradeImageView: UIImageView!
  @IBOutlet private var primaryLabel: UILabel!
  @IBOutlet private var secondaryLabel: UILabel!
  @IBOutlet private var tertiaryLabel: UILabel!

  private var cancellables = Set<AnyCancellable>()

  override func awakeFromNib() {
    super.awakeFromNib()
    posterImageView.image = UIImage(named: "img_placeholder")

    primaryLabel.minimumScaleFactor = 0.5
    primaryLabel.adjustsFontSizeToFitWidth = true

    secondaryLabel.minimumScaleFactor = 0.5
    secondaryLabel.adjustsFontSizeToFitWidth = true

    tertiaryLabel.minimumScaleFactor = 0.5
    tertiaryLabel.adjustsFontSizeToFitWidth = true
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    posterImageView.image = UIImage(named: "img_placeholder")
    gradeImageView.image = nil
    primaryLabel.text = nil
    secondaryLabel.text = nil
    tertiaryLabel.text = nil
  }

  func configure(with movie: MoviesResponseModel.Movie) {
    networkImageData(from: movie.thumb)
      .replaceError(with: NSDataAsset(name: "img_placeholder")?.data)
      .compactMap { $0 }
      .map(UIImage.init)
      .assign(to: \.image, on: posterImageView)
      .store(in: &cancellables)

    let grade = Grade(rawValue: movie.grade) ?? .allAges
    gradeImageView.image = UIImage(named: grade.imageName)

    primaryLabel.text = movie.title
    primaryLabel.textColor = .label
    primaryLabel.font = .preferredFont(forTextStyle: .title2)

    secondaryLabel.text = """
    평점 : \(movie.userRating) 예매순위 : \(movie.reservationGrade) 예매율 : \(movie.reservationRate)%
    """
    secondaryLabel.textColor = .secondaryLabel
    secondaryLabel.font = .preferredFont(forTextStyle: .body)

    tertiaryLabel.text = "개봉일 : \(movie.date)"
    tertiaryLabel.textColor = .secondaryLabel
    tertiaryLabel.font = .preferredFont(forTextStyle: .body)
  }
}
