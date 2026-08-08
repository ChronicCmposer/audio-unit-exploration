//
//  audio_unit_explorationApp.swift
//  audio-unit-exploration
//
//  Created by Connor on 8/7/26.
//

import SwiftUI

@main
struct audio_unit_explorationApp: App {
    private let hostModel = AudioUnitHostModel()

    var body: some Scene {
        WindowGroup {
            ContentView(hostModel: hostModel)
        }
    }
}
