import WidgetKit
import SwiftUI

struct ClockEntry: TimelineEntry {
    let date: Date
}

struct ClockTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> ClockEntry {
        ClockEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (ClockEntry) -> Void) {
        completion(ClockEntry(date: Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ClockEntry>) -> Void) {
        let now = Date()
        let calendar = Calendar.current

        // Generate entries for the next 60 minutes, one per minute
        var entries: [ClockEntry] = []
        for minuteOffset in 0..<60 {
            if let entryDate = calendar.date(byAdding: .minute, value: minuteOffset, to: now) {
                // Round to the start of the minute
                let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: entryDate)
                if let roundedDate = calendar.date(from: components) {
                    entries.append(ClockEntry(date: roundedDate))
                }
            }
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct ClockWidget: Widget {
    let kind: String = "ClockWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ClockTimelineProvider()) { entry in
            let colorMode = PetManager.loadWidgetColorMode()
            ClockWidgetEntryView(entry: entry)
                .containerBackground(for: .widget) {
                    if colorMode == .petColor {
                        ZStack {
                            Color(.systemBackground)
                            LinearGradient(
                                colors: [
                                    widgetPetAccentColor().opacity(0.15),
                                    widgetPetAccentColor().opacity(0.03)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        }
                    } else {
                        Color(.systemBackground)
                    }
                }
        }
        .configurationDisplayName("日本語時計")
        .description("日本語で時刻を表示するウィジェット")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

@main
struct ClockWidgetBundle: WidgetBundle {
    var body: some Widget {
        ClockWidget()
    }
}
