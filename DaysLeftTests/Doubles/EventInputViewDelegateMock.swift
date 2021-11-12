//  Created by Dominik Hauser on 24.08.21.
//  Copyright © 2021 dasdom. All rights reserved.
//

import Foundation
@testable import fourtytwodays

// MARK: - EventInputViewDelegateMock -

final class EventInputViewDelegateMock: EventInputViewDelegate {

  // MARK: - addEventWith

  var addEventWithNameDateCallsCount = 0
  var addEventWithNameDateCalled: Bool {
    addEventWithNameDateCallsCount > 0
  }
  var addEventWithNameDateReceivedArguments: (name: String, date: Date)?
  var addEventWithNameDateReceivedInvocations: [(name: String, date: Date)] = []
  var addEventWithNameDateClosure: ((String, Date) -> Void)?

  func addEventWith(name: String, date: Date) {
    addEventWithNameDateCallsCount += 1
    addEventWithNameDateReceivedArguments = (name: name, date: date)
    addEventWithNameDateReceivedInvocations.append((name: name, date: date))
    addEventWithNameDateClosure?(name, date)
  }

  // MARK: - importFromContacts

  var importFromContactsCallsCount = 0
  var importFromContactsCalled: Bool {
    importFromContactsCallsCount > 0
  }
  var importFromContactsClosure: (() -> Void)?

  func importFromContacts() {
    importFromContactsCallsCount += 1
    importFromContactsClosure?()
  }
}
