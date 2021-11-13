//  Created by Dominik Hauser on 12.11.21.
//  Copyright © 2021 dasdom. All rights reserved.
//

import SwiftUI

struct EventsListView: View {

  let events: ArraySlice<Event>
  let eventStore: EventStore

  var body: some View {
    ForEach(events) { event in
      EventView(event: event, eventStore: eventStore)
    }
  }
}
