//  Created by Dominik Hauser on 25.08.21.
//  Copyright © 2021 dasdom. All rights reserved.
//

import UIKit
import SwiftUI
import Contacts

class EventsCoordinator: Coordinator {

  let presenter: UINavigationController
  let eventStore: EventStoreProtocol
  var viewController: UIViewController?

  init(presenter: UINavigationController = UINavigationController(), eventStore: EventStoreProtocol = EventStore()) {
    self.presenter = presenter
    self.eventStore = eventStore
  }

  func start() {
    let eventsList = EventsListViewController()
    eventsList.delegate = self
    eventsList.eventStore = eventStore

    presenter.pushViewController(eventsList, animated: true)

    viewController = eventsList
  }
}

extension EventsCoordinator: EventsListViewControllerDelegate {
  func addSelected(_ viewController: UIViewController) {
    let next = UIHostingController(rootView: EventInputView())
    presenter.present(next, animated: true)
    next.rootView.delegate = self
  }
}

extension EventsCoordinator: EventInputViewDelegate {
  func importFromContacts() {
    let contactStore = CNContactStore()
    contactStore.requestAccess(for: .contacts) { [weak self] granted, error in
      guard granted else {
        return
      }
      let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactBirthdayKey, CNContactEmailAddressesKey, CNContactThumbnailImageDataKey] as [CNKeyDescriptor]
      let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
      do {
        try contactStore.enumerateContacts(with: fetchRequest) { [weak self] contact, _ in
          if let birthday = contact.birthday?.date {
            let name = "\(contact.givenName) \(contact.familyName)"
            self?.eventStore.add(Event(name: name, date: birthday, thumbnailData: contact.thumbnailImageData))
          }
        }
        self?.presenter.dismiss(animated: true)
      } catch {
        print("error \(#file): \(error)")
      }
    }
  }

  func addEventWith(name: String, date: Date) {
    eventStore.add(Event(name: name, date: date))
    presenter.dismiss(animated: true)
  }
}
