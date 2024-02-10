//
//  backgroundIntent.swift
//  Runner
//
//  Created by Jeanie Cho on 2/9/24.
//

import AppIntents
import Foundation
import home_widget

@available(iOS 17, *)
public struct BackgroundIntent: AppIntent {
  static public var title: LocalizedStringResource = "Increment Counter"

  @Parameter(title: "Method")
  var method: String

  public init() {
    method = "increment"
  }

  public init(method: String) {
    self.method = method
  }

  public func perform() async throws -> some IntentResult {
    await HomeWidgetBackgroundWorker.run(
      url: URL(string: "homeWidgetTasks://\(method)"),
      appGroup: "group.dev.jeanie.habitApp.habitWidgets")

    return .result()
  }
}
