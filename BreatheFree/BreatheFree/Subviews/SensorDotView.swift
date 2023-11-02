//
//  SensorDotView.swift
//  Breathe
//
//  Created by Jacob Trentini on 10/27/22.
//

import SwiftUI
import BreatheShared

struct SensorDotView: View {
    let airQuality:               AirQuality
    let radius:                   CGFloat
    let textSize:                 CGFloat
    let isShowingTextSize:        Bool
    let isAdaptiveColorOverriden: Bool
    
    init(airQuality:             AirQuality,
         radius:                 CGFloat = 40,
         textSize:               CGFloat = 14,
         isShowingTextSize:      Bool    = true,
         overridesAdaptiveColor: Bool    = false
    ) {
        self.airQuality               = airQuality
        self.radius                   = radius
        self.textSize                 = textSize
        self.isShowingTextSize        = isShowingTextSize
        self.isAdaptiveColorOverriden = overridesAdaptiveColor
    }
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Color(!isAdaptiveColorOverriden ? airQuality.airQualityCategory.airQualityColor.adaptiveColor : airQuality.airQualityCategory.airQualityColor.primaryColor))
                .frame(width: radius, height: radius)
            
            if isShowingTextSize {
                Text("\(airQuality.aqi)")
                    .font(.system(size: textSize))
                    .foregroundColor(.white)
            }
        }
    }
}

struct SensorDotView_Previews: PreviewProvider {
    static var previews: some View {
        SensorDotView(airQuality: AirQuality(aqi: 401), radius: 50, overridesAdaptiveColor: true)
    }
}
