//  Created by Dominik Hauser on 18.08.21.
//  
//

import UIKit

class EventsListViewController: UIViewController {

  @IBOutlet var tableView: UITableView!
  var eventStore: EventStoreProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.dataSource = self
  }
}

extension EventsListViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let eventStore = eventStore else {
      return 0
    }
    return eventStore.numberOfEvents()
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell()
  }


}
