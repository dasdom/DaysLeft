//  Created by Dominik Hauser on 18.08.21.
//  
//

import XCTest
@testable import DaysLeft

class EventsListViewControllerTests: XCTestCase {

  var sut: EventsListViewController!

  override func setUpWithError() throws {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    sut = (storyboard.instantiateViewController(withIdentifier: "EventsListViewController") as! EventsListViewController)
  }

  override func tearDownWithError() throws {
    sut = nil
  }

  func test_shouldBeLoadedFromStoryboard() {
    XCTAssertNotNil(sut)
  }
}
