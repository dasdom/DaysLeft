//  Created by Dominik Hauser on 25.08.21.
//  Copyright © 2021 dasdom. All rights reserved.
//

import XCTest
import ViewControllerModalRecorder
import SwiftUI
import Combine
@testable import fourtytwodays

class EventsCoordinatorTests: XCTestCase {

  var sut: EventsCoordinator!
  var eventStoreMock: EventStoreProtocolMock!

  override func setUpWithError() throws {
    eventStoreMock = EventStoreProtocolMock()
    eventStoreMock.eventsPublisher = CurrentValueSubject<[Event], Never>([])
    sut = EventsCoordinator(eventStore: eventStoreMock)
  }

  override func tearDownWithError() throws {
    sut = nil
    eventStoreMock = nil
  }

  func test_start_shouldPushEventsListOntoNavigationController() throws {
    // act
    sut.start()

    // arrange
    executeRunloop()
    let eventsList = try XCTUnwrap(sut.presenter.topViewController as? EventsListViewController)
    eventsList.loadViewIfNeeded()

    XCTAssertNotNil(eventsList.tableView) // test if view controller was loaded from storyboard
    XCTAssertIdentical(eventsList.delegate as? EventsCoordinator, sut)
    XCTAssertIdentical(eventsList.eventStore, sut.eventStore)
  }

  func test_addSelected_shouldPresentInputView() throws {
    // arrange
    let recorder = ViewControllerModalRecorder()
    let viewController = UIViewController()

    // act
    sut.addSelected(viewController)

    // assert
    let modal = try XCTUnwrap(recorder.getLastPresented() as? UIHostingController<EventInputView>)
    XCTAssertIdentical(modal.rootView.delegate as? EventsCoordinator, sut)
  }

  func test_addEventWith_shouldCallEventStore() {
    // arrange
    let event = Event(name: "Foobar", date: Date())

    // act
    sut.addEventWith(name: event.name, date: event.date)

    // assert
    XCTAssertEqual(eventStoreMock.addReceivedEvent?.name, event.name)
    XCTAssertEqual(eventStoreMock.addReceivedEvent?.date, event.date)
  }

  func test_addEventWith_shouldDismissViewController() {
    // arrange
    let recorder = ViewControllerModalRecorder()
    let event = Event(name: "Foobar", date: Date())

    // act
    sut.addEventWith(name: event.name, date: event.date)

    // assert
    XCTAssertEqual(recorder.getLastDismissed(), sut.presenter)
  }
}

func executeRunloop() {
  RunLoop.main.run(until: Date())
}
