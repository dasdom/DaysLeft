//  Created by Dominik Hauser on 25.08.21.
//  Copyright © 2021 dasdom. All rights reserved.
//

import UIKit

class EventsCoordinator: Coordinator {

  let presenter: UINavigationController
  var viewController: UIViewController?

  init(presenter: UINavigationController = UINavigationController()) {
    self.presenter = presenter
  }

  func start() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let eventsList = storyboard.instantiateViewController(withIdentifier: "EventsListViewController") as! EventsListViewController
    eventsList.delegate = self

    presenter.pushViewController(eventsList, animated: true)

    viewController = eventsList
  }
}

extension EventsCoordinator: EventsListViewControllerDelegate {
  func addSelected(_ viewController: UIViewController) {
    
  }
}
