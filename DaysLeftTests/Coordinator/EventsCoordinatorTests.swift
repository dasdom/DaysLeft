//  Created by Dominik Hauser on 25.08.21.
//  Copyright © 2021 dasdom. All rights reserved.
//

import XCTest
@testable import DaysLeft

class EventsCoordinatorTests: XCTestCase {

  var sut: EventsCoordinator!

  override func setUpWithError() throws {
    sut = EventsCoordinator()
  }

  override func tearDownWithError() throws {
    sut = nil
  }

  func test_start_pushesEventsListOntoNavigationController() throws {
    // act
    sut.start()

    // arrange
    executeRunloop()
    let eventsList = try XCTUnwrap(sut.presenter.topViewController as? EventsListViewController)
    eventsList.loadViewIfNeeded()
    XCTAssertNotNil(eventsList.tableView) // test if view controller was loaded from storyboard
    XCTAssertIdentical(eventsList.delegate as? EventsCoordinator, sut)
  }  
}

func executeRunloop() {
  RunLoop.main.run(until: Date())
}
