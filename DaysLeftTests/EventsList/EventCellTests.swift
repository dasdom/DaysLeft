//  Created by Dominik Hauser on 19.08.21.
//  
//

import XCTest
@testable import DaysLeft

class EventCellTests: XCTestCase {

  var sut: EventCell!

  override func setUpWithError() throws {
    sut = EventCell()
  }

  override func tearDownWithError() throws {
    sut = nil
  }

  func test_init_shouldAddNameLabelToContentView() {
    // assert
    XCTAssertTrue(sut.nameLabel.isDescendant(of: sut.contentView),
                  "nameLabel is not descendant of contentView")
  }

  func test_init_shouldAddRemainingDaysLabelToContentView() {
    // assert
    XCTAssertTrue(sut.remainingDaysLabel.isDescendant(of: sut.contentView),
                  "remainingDaysLabel is not descendant of contentView")
  }
}
