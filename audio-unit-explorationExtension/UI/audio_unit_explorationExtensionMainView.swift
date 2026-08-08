//
//  audio_unit_explorationExtensionMainView.swift
//  audio-unit-explorationExtension
//
//  Created by Connor on 8/7/26.
//

import SwiftUI

struct audio_unit_explorationExtensionMainView: View {
    var parameterTree: ObservableAUParameterGroup
    
    var body: some View {
        ParameterSlider(param: parameterTree.global.gain)
    }
}
