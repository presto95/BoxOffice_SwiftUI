//
//  SampleWidget.swift
//  BoxOffice
//
//  Created by Presto on 2021/07/01.
//  Copyright © 2021 presto. All rights reserved.
//

import WidgetKit
import SwiftUI

struct SampleWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Sample", provider: Provider()) { entry in
            Text("Sample")
        }
        .configurationDisplayName("BoxOffice")
        .description("Sample BoxOffice")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

extension SampleWidget {
    struct Provider: TimelineProvider {
        typealias Entry = SampleWidget.Entry

        func placeholder(in context: Context) -> SampleWidget.Entry {
            return Entry(date: Date())
        }

        func getSnapshot(in context: Context, completion: @escaping (SampleWidget.Entry) -> Void) {
            completion(Entry(date: Date()))
        }

        func getTimeline(in context: Context, completion: @escaping (Timeline<SampleWidget.Entry>) -> Void) {
            let entry = Entry(date: Date())
            let timeline = Timeline(entries: [entry], policy: .never)
            completion(timeline)
        }
    }

    struct Entry: TimelineEntry {
        var date: Date
    }
}
