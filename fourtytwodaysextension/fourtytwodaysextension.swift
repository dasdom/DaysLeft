//  Created by Dominik Hauser on 12.11.21.
//  Copyright © 2021 dasdom. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entries: [SimpleEntry] = [SimpleEntry(date: Date())]

//        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate)
//            entries.append(entry)
//        }

//      let calendar = Calendar.current
//      let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date()) ?? Date(timeIntervalSinceNow: 24 * 60 * 60)
//      let tomorrowStartOfDay = calendar.date(bySettingHour: 0, minute: 0, second: 1, of: tomorrow) ?? Date(timeIntervalSinceNow: 60 * 60)
//      let timeline = Timeline(entries: entries, policy: .after(tomorrowStartOfDay))
      let timeline = Timeline(entries: entries, policy: .atEnd)
      completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct fourtytwodaysextensionEntryView : View {
    var entry: Provider.Entry

    let eventStore = EventStore()

    var body: some View {
      EventsListView(events: eventStore.events.prefix(4) , eventStore: eventStore)
        .padding(10)
    }
}

@main
struct fourtytwodaysextension: Widget {
    let kind: String = "fourtytwodaysextension"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            fourtytwodaysextensionEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct fourtytwodaysextension_Previews: PreviewProvider {
    static var previews: some View {
        fourtytwodaysextensionEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
