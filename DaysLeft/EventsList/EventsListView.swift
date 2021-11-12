//  Created by Dominik Hauser on 12.11.21.
//  Copyright © 2021 dasdom. All rights reserved.
//

import UIKit

class EventsListView: UIView {

  let tableView: UITableView

  override init(frame: CGRect) {

    tableView = UITableView().forAutoLayout()

    super.init(frame: frame)

    addSubview(tableView)

    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: topAnchor),
      tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
      tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
