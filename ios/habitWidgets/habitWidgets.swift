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
        SimpleEntry(date: Date(), tasks: "aa")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let prefs = UserDefaults.init(suiteName: "group.dev.jeanie.habitApp.habitWidgets")
        let entry = SimpleEntry(date: Date(), tasks: prefs?.string(forKey: "counter") ?? "none")
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
    let tasks: String
}

struct habitWidgetsEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text(entry.tasks).font(.caption2).frame(
                maxWidth: .infinity)
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
        .configurationDisplayName("Task  Widget")
        .description("Get list of tasks")
    }
}

#Preview(as: .systemSmall) {
    habitWidgets()
} timeline: {
    SimpleEntry(date: .now, tasks: "task preview")
}
