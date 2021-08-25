//  Created by Dominik Hauser on 24.08.21.
//  Copyright © 2021 dasdom. All rights reserved.
//

import Foundation
@testable import DaysLeft

class EventInputViewDelegateMock: EventInputViewDelegate {

  var nameInput: String?
  var dateInput: Date?

  func addEventWith(name: String, date: Date) {
    nameInput = name
    dateInput = date
  }
}
