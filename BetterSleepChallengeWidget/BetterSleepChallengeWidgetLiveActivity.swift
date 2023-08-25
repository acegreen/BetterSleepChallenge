//
//  BetterSleepChallengeWidgetLiveActivity.swift
//  BetterSleepChallengeWidget
//
//  Created by Ace Green on 2023-08-24.
//

import ActivityKit
import WidgetKit
import SwiftUI

enum RecordingStatus: Float, Codable, Hashable {
    case upcoming = 0
    case ongoing
    case ended

    var description: String {
        switch self {
        case .upcoming:
            return "Recording about to start"
        case .ongoing:
            return "Recording ongoing"
        case .ended:
            return "Your recording is complete"
        }
    }
}

struct BetterSleepChallengeWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var status: RecordingStatus
        var startDate: Date
        var endDate: Date
    }
}

struct BetterSleepChallengeWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BetterSleepChallengeWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            HStack(spacing: 16) {
                Image(systemName: "bed.double.fill")
                    .resizable()
                    .frame(width: 48, height: 48)
                Text(context.state.startDate, style: .relative)
            }
            .padding()
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "bed.double.fill")
                        .resizable()
                        .frame(width: 48, height: 48)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.startDate, style: .relative)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    // more content
                }
            } compactLeading: {
                Image(systemName: "bed.double.fill")
            } compactTrailing: {
                Text(context.state.startDate, style: .relative)
            } minimal: {
                Text(context.state.status.description)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension BetterSleepChallengeWidgetAttributes {
    fileprivate static var preview: BetterSleepChallengeWidgetAttributes {
        BetterSleepChallengeWidgetAttributes()
    }
}

extension BetterSleepChallengeWidgetAttributes.ContentState {
    static var upcoming: BetterSleepChallengeWidgetAttributes.ContentState {
        let startDate = Date().addingTimeInterval(60 * 30)
        return BetterSleepChallengeWidgetAttributes.ContentState(status: .upcoming, startDate: startDate,
                                                          endDate: startDate.addingTimeInterval(60 * 60 * 8))
    }

    static var started: BetterSleepChallengeWidgetAttributes.ContentState {
        BetterSleepChallengeWidgetAttributes.ContentState(status: .ongoing, startDate: .now,
                                                          endDate: Date().addingTimeInterval(60 * 60 * 8))
    }

    static var ended: BetterSleepChallengeWidgetAttributes.ContentState {
        BetterSleepChallengeWidgetAttributes.ContentState(status: .ongoing, startDate: .now,
                                                          endDate: Date().addingTimeInterval(60 * 60 * 8))
    }
}

#Preview("Notification", as: .content, using: BetterSleepChallengeWidgetAttributes.preview) {
    BetterSleepChallengeWidgetLiveActivity()
} contentStates: {
    BetterSleepChallengeWidgetAttributes.ContentState.upcoming
    BetterSleepChallengeWidgetAttributes.ContentState.started
}
