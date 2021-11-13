//  Created by Dominik Hauser on 19.08.21.
//  
//

import UIKit

class EventCell: UITableViewCell {
  let thumbnailImageView: UIImageView
  let nameLabel: UILabel
  let remainingDaysLabel: UILabel

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

    thumbnailImageView = UIImageView()
    nameLabel = UILabel()
    remainingDaysLabel = UILabel()

    super.init(style: style, reuseIdentifier: reuseIdentifier)

    let stackView = UIStackView(arrangedSubviews: [thumbnailImageView, nameLabel, remainingDaysLabel]).forAutoLayout()
    stackView.spacing = 5

    contentView.addSubview(stackView)

    let thumbnailHeightConstraint = thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor)
    thumbnailHeightConstraint.priority = UILayoutPriority(999)

    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

      thumbnailImageView.widthAnchor.constraint(equalToConstant: 40),
      thumbnailHeightConstraint
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
