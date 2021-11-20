//  Created by Dominik Hauser on 23.08.21.
//
//

import SwiftUI

protocol EventInputViewDelegate {
  func addEventWith(name: String, date: Date)
  func importFromContacts()
}

struct EventInputView: View {

  @State var name: String = ""
  @State var date: Date = Date()
  var delegate: EventInputViewDelegate?
  internal var didAppear: ((Self) -> Void)?

  var body: some View {
    VStack {
      TextField("Name", text: $name)
      DatePicker("Date", selection: $date)
      Button("Save") {
        delegate?.addEventWith(name: name, date: date)
      }
      Button("Import") {
        delegate?.importFromContacts()
      }
    }
    .padding()
    .onAppear { self.didAppear?(self) }
  }
}

struct EventInputView_Previews: PreviewProvider {
    static var previews: some View {
        EventInputView()
    }
}

