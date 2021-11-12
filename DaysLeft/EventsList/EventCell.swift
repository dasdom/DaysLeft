//  Created by Dominik Hauser on 19.08.21.
//  
//

import UIKit

class EventCell: UITableViewCell {
  let nameLabel: UILabel
  let remainingDaysLabel: UILabel

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

    nameLabel = UILabel()
    remainingDaysLabel = UILabel()

    super.init(style: style, reuseIdentifier: reuseIdentifier)

    let stackView = UIStackView(arrangedSubviews: [nameLabel, remainingDaysLabel]).forAutoLayout()

    contentView.addSubview(stackView)

    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
