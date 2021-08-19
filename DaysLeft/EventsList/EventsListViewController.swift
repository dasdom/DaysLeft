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

    tableView.register(EventCell.self, forCellReuseIdentifier: "EventCell")
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

    let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell

    if let event = eventStore?.eventAt(index: indexPath.row) {
      cell.nameLabel.text = event.name
    }

    return cell
  }


}
