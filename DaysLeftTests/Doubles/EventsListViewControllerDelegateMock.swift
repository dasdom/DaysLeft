//  Created by Dominik Hauser on 26.08.21.
//  Copyright © 2021 dasdom. All rights reserved.
//

import UIKit
@testable import fourtytwodays

class EventsListViewControllerDelegateMock: EventsListViewControllerDelegate {

  var addSelectedCallCount = 0

  func addSelected(_ viewController: UIViewController) {
    addSelectedCallCount += 1
  }
}
