//
//  Static_Widget.swift
//  Static Widget
//
//  Created by Igor Bragaia on 11/17/20.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> QuoteEntry {
        let quotePlaceholder = Quote(text:"aaa", author: "cde", reference: "fgh")
        return QuoteEntry(date: Date(), quote: quotePlaceholder )
    }

    func getSnapshot(in context: Context, completion: @escaping (QuoteEntry) -> ()) {
        let quotePlaceholder = Quote(text:"bbb", author: "cde", reference: "fgh")
        let entry = QuoteEntry(date: Date(), quote: quotePlaceholder )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<QuoteEntry>) -> ()) {
        QuoteLoader.fetch { result in
            let quote: Quote
            if case Result.success(let fetchedQuote) = result {
                quote = fetchedQuote
            } else {
                quote = Quote(text:"Error", author: "---", reference: "---")
            }

            let entry = QuoteEntry(date: Date(), quote: quote )
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct QuoteLoader {
    static var quotes = [
        Quote(text: "\"You got into this elite institution. Your worries are over. You're set for life\". That's probably the kind of thing that's true only if you don't believe it.", author: "Peter Thiel", reference: "Zero to One")
    ]

    static func fetch(completion: @escaping (Result<Quote, Error>) -> Void) {
        completion(.success(quotes[0]))
    }
}

struct Quote {
    let text: String
    let author: String
    let reference: String
}

struct QuoteEntry : TimelineEntry {
    var date: Date
    let quote: Quote
}

struct Static_WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack{
            Text(entry.quote.text)
                .font(.footnote)
            Text(entry.quote.reference)
                .font(.footnote)
                .italic()
        }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [.orange, .yellow]), startPoint: .top, endPoint: .bottom))
    }
}

@main
struct Static_Widget: Widget {
    let kind: String = "Static_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Static_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Book Wisdom")
        .description("Get inspiration from the quotes best recommended.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct Static_Widget_Previews: PreviewProvider {
    static var previews: some View {
        Static_WidgetEntryView(entry: QuoteEntry(date: Date(), quote: QuoteLoader.quotes[0]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
