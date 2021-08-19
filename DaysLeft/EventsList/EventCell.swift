//  Created by Dominik Hauser on 19.08.21.
//  
//

import UIKit

class EventCell: UITableViewCell {
  let nameLabel: UILabel

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

    nameLabel = UILabel()

    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
