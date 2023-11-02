//
//  CityView.swift
//  Breathe
//
//  Created by Jacob Trentini on 10/27/22.
//

import SwiftUI
import BreatheShared

struct CityView: View {
    let airQuality: AirQuality
    let locality:   String
    
    init(airQuality: AirQuality, locality: String) {
        self.airQuality = airQuality
        self.locality   = locality
    }
    
    var body: some View {
        ZStack {
            Capsule()
                .fill(Color(airQuality.airQualityCategory.airQualityColor.primaryColor))
                .frame(width: calculateCapsuleWidth(), height: 35)
            
            HStack {
                Text("\(airQuality.aqi)")
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
                
                Text(locality)
                    .font(.system(size: 16))
                    .foregroundStyle(Color(airQuality.airQualityCategory.airQualityColor.secondaryColor))
            }
        }
    }
    
    private func calculateCapsuleWidth() -> CGFloat {
        let label = UILabel()
        label.text = "\(locality) \(airQuality.aqi)"
        return label.intrinsicContentSize.width + 25
    }
}

#Preview {
    CityView(airQuality: .init(aqi: 50), locality: "San Francisco")
}
