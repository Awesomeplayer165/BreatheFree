//
//  FavoritePanelView.swift
//  Breathe
//
//  Created by Jacob Trentini on 7/18/23.
//

import Foundation
import BreatheShared
import SwiftUI

struct FavoritePanelView: View {
    public let sensor: Sensor
    
    var body: some View {
        RoundedRectangle(cornerRadius: 13)
            .fill(.regularMaterial)
            .overlay {
                VStack {
                    Text(sensor.name)
                    Text(sensor.locationType == .outdoor ? "Outdoor" : "Indoor")
                    
                    ScrollView(.horizontal) {
                        RoundedRectangle(cornerRadius: 13)
                            .stroke(.black, lineWidth: 1)
                            .overlay {
                                Text("Air Quality")
                                Text("\(sensor.airQuality.aqi)")
                            }
                        
                        RoundedRectangle(cornerRadius: 13)
                            .stroke(.black, lineWidth: 1)
                            .overlay {
                                Text("Air Quality")
                                Text("\(sensor.airQuality.aqi)")
                            }
                    }
                }
            }
    }
}

#Preview {
    FavoritePanelView(sensor: Sensor(index: 0, name: "Alberta Glen", coordinate: .init(latitude: 0, longitude: 0), airQuality: .init(aqi: 76), temperature: 57, humidity: 45, locationType: .outdoor, lastUpdated: .now))
}
