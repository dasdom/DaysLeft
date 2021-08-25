//  Created by Dominik Hauser on 23.08.21.
//  
//

import XCTest
@testable import DaysLeft
import ViewInspector

extension EventInputView: Inspectable {}

class EventInputViewTests: XCTestCase {

  var sut: EventInputView!

  override func setUpWithError() throws {
    sut = EventInputView()
  }

  override func tearDownWithError() throws {
    sut = nil
  }

  func test_shouldAllowNameInput() throws {
    var input: String?
    let exp = sut.on(\.didAppear) { view in
      try view.find(ViewType.TextField.self).setInput("Foobar")
      input = try view.actualView().name
    }

    ViewHosting.host(view: sut)
    wait(for: [exp], timeout: 1)
    XCTAssertEqual(input, "Foobar")
  }

  func test_shouldAllowDateInput() {
    let expectedDate = Date(timeIntervalSinceNow: -200_000)

    var input: Date?
    let exp = sut.on(\.didAppear) { view in
      try view.find(ViewType.DatePicker.self).select(date: expectedDate)
      input = try view.actualView().date
    }

    ViewHosting.host(view: sut)
    wait(for: [exp], timeout: 1)
    XCTAssertEqual(input, expectedDate)
  }

  func test_tapSaveButton_shouldCallDelegate() throws {
    let delegateMock = EventInputViewDelegateMock()
    sut.delegate = delegateMock
    let expectedDate = Date(timeIntervalSinceNow: -200_000)
    let exp = sut.on(\.didAppear) { view in
      try view.find(ViewType.TextField.self).setInput("Foobar")
      try view.find(ViewType.DatePicker.self).select(date: expectedDate)

      try view.find(ViewType.Button.self).tap()
    }
    ViewHosting.host(view: sut)
    wait(for: [exp], timeout: 1)

    XCTAssertEqual(delegateMock.nameInput, "Foobar")
    XCTAssertEqual(delegateMock.dateInput, expectedDate)
  }
}
