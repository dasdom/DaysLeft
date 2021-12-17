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
      } else {
        ZStack {
          Circle()
            .foregroundColor(.gray)
          Text(initials(event: event))
            .font(Font.system(size: 9))
            .foregroundColor(.white)
        }
        .frame(width: 20, height: 20, alignment: .center)
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

  func initials(event: Event) -> String {
    var initials = ""
    if let character = event.name.first {
      initials.append(contentsOf: character.uppercased())
    }
    if let character = event.lastName?.first {
      initials.append(contentsOf: character.uppercased())
    }
    return initials
  }
}

