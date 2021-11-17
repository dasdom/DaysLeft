//  Created by Dominik Hauser on 12.11.21.
//  Copyright © 2021 dasdom. All rights reserved.
//

import SwiftUI

struct EventView: View {

  let event: Event
  let eventStore: EventStore

  var body: some View {
    HStack {
      if let data = event.thumbnailData, let uiImage = UIImage(data: data) {
        Image(uiImage: uiImage)
          .resizable()
          .frame(width: 20, height: 20)
          .clipShape(Circle())
      }
      Text(event.name)
        .font(.subheadline)
        .bold()
      Spacer()
      Text("\(eventStore.remainingDaysUntil(event))")
        .font(.subheadline)
        .bold()
    }
  }
}

