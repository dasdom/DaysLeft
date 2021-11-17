//  Created by Dominik Hauser on 19.08.21.
//  
//

import UIKit

class EventCell: UITableViewCell {
  let thumbnailImageView: UIImageView
  let nameLabel: UILabel
  let dateLabel: UILabel
  let remainingDaysLabel: UILabel

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

    thumbnailImageView = UIImageView()
    thumbnailImageView.clipsToBounds = true

    nameLabel = UILabel()
    nameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
    nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

    dateLabel = UILabel()
    dateLabel.font = UIFont.preferredFont(forTextStyle: .footnote)

    let nameAndDateStackView = UIStackView(arrangedSubviews: [nameLabel, dateLabel])
    nameAndDateStackView.axis = .vertical

    remainingDaysLabel = UILabel()
    remainingDaysLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

    super.init(style: style, reuseIdentifier: reuseIdentifier)

    let stackView = UIStackView(arrangedSubviews: [thumbnailImageView, nameAndDateStackView, remainingDaysLabel]).forAutoLayout()
    stackView.spacing = 10

    contentView.addSubview(stackView)

    let thumbnailHeightConstraint = thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor)
    thumbnailHeightConstraint.priority = UILayoutPriority(999)

    let thumbnailWidth: CGFloat = 40

    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

      thumbnailImageView.widthAnchor.constraint(equalToConstant: thumbnailWidth),
      thumbnailHeightConstraint
    ])

    thumbnailImageView.layer.cornerRadius = floor(thumbnailWidth / 2)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
