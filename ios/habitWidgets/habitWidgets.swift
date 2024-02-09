//
//  habitWidgets.swift
//  habitWidgets
//
//  Created by Jeanie Cho on 2/9/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), count: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let prefs = UserDefaults(suiteName: "dev.jeanie.habitApp.habitWidgets")
        let entry = SimpleEntry(date: Date(), count: prefs?.integer(forKey: "counter") ?? -1)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getSnapshot(in: context) { (entry) in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let count: Int
}

struct habitWidgetsEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("You have pushed the button this many times:").font(.caption2).frame(
                maxWidth: .infinity, alignment: .center)
            Spacer()
            Text(entry.count.description).font(.title).frame(maxWidth: .infinity, alignment: .center)
            Spacer()
            HStack {
                // This button is for clearing
                Button(intent: BackgroundIntent(method: "clear")) {
                Image(systemName: "xmark").font(.system(size: 16)).foregroundColor(.red).frame(
                    width: 24, height: 24)
                }.buttonStyle(.plain).frame(alignment: .leading)
                Spacer()
                // This button is for incrementing
                Button(intent: BackgroundIntent(method: "increment")) {
                Image(systemName: "plus").font(.system(size: 16)).foregroundColor(.white)

                }.frame(width: 24, height: 24)
                .background(.blue)
                .cornerRadius(12).frame(alignment: .trailing)
            }
        }
    }
}

struct habitWidgets: Widget {
    let kind: String = "habitWidgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                habitWidgetsEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                habitWidgetsEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Counter Widget")
        .description("Count the Number Up")
    }
}

#Preview(as: .systemSmall) {
    habitWidgets()
} timeline: {
    SimpleEntry(date: .now, count: 0)
}
