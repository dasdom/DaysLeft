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

    contentView.addSubview(nameLabel)
    contentView.addSubview(remainingDaysLabel)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
