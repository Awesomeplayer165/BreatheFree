//
//  AirQualityInformationView.swift
//  Breathe
//
//  Created by Jacob Trentini on 10/28/22.
//

import SwiftUI
import BreatheShared
import BreatheLogic

struct AirQualityInformationView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State private var isParticulateMatterGroupExpanded = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Text("The Air Quality index is a U.S. standard of measuring how clean the air is. AQI is measured by Particulate Matter PM₂.₅")
                }
                
                Section {
                    DisclosureGroup(
                        isExpanded: $isParticulateMatterGroupExpanded,
                        content: {
                            Text("PM₂.₅ are tiny particles in the air that reduce visibility and cause the air to appear hazy when levels are elevated. Particles in the PM₂.₅ size range are able to travel deeply into the respiratory tract, reaching the lungs. Exposure to fine particles can cause short-term and long-term health effects.")
                        }, label: {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Primary Pollutant")
                                    .font(.headline)
                                
                                Text("PM₂.₅ - particulate matter smaller than 2.5μm")
                                    .foregroundStyle(.secondary)
                                    .font(.system(size: 14))
                            }
                        }
                    )
                }

                ForEach(AirQualityCategories.all, id: \.name) { airQualityCategory in
                    HStack(spacing: 10) {
                        SensorDotView(airQuality: AirQuality(aqi: airQualityCategory.range.lowerBound), overridesAdaptiveColor: true)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("\(airQualityCategory.name) - \(airQualityCategory.range.lowerBound) to \(airQualityCategory.range.upperBound)")
                                .foregroundColor(Color(airQualityCategory.airQualityColor.adaptiveColor))
                            Text(airQualityCategory.description)
                        }
                    }
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("Air Quality")
            .toolbar {
                ToolbarItem {
                    CloseButtonView(presentationMode: presentationMode)
                }
            }
        }
    }
}

struct AirQualityInformationView_Previews: PreviewProvider {
    static var previews: some View {
        AirQualityInformationView()
    }
}

struct CloseButtonView: View {
    var presentationMode: Binding<PresentationMode>
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button {
            if let action = action {
                action()
            } else {
                presentationMode.wrappedValue.dismiss()
            }
        } label: {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(.gray.opacity(0.6))
        }
    }
}
