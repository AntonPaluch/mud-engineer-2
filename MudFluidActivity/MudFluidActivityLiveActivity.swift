//
//  MudFluidActivityLiveActivity.swift
//  MudFluidActivity
//
//  Created by Павлов Дмитрий on 14.11.2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct MudFluidActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct MudFluidActivityLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MudFluidActivityAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension MudFluidActivityAttributes {
    fileprivate static var preview: MudFluidActivityAttributes {
        MudFluidActivityAttributes(name: "World")
    }
}

extension MudFluidActivityAttributes.ContentState {
    fileprivate static var smiley: MudFluidActivityAttributes.ContentState {
        MudFluidActivityAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: MudFluidActivityAttributes.ContentState {
         MudFluidActivityAttributes.ContentState(emoji: "🤩")
     }
}

