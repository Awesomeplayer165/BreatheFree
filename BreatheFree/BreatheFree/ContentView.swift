//
//  ContentView.swift
//  BreatheFree
//
//  Created by Jacob Trentini on 1/4/24.
//

import Foundation
import SwiftUI
import BreatheLogic
import BreatheShared
import MapKit
import GameplayKit

struct ContentView: View {
    @EnvironmentObject private var appSharedModel: AppSharedModel
    @State private var isAirQualityInformationViewPresented = false
    @State private var isLinkedCityViewPresented = false
    @State private var mapViewRepresentable = MapViewRepresentable()
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        ZStack {
            mapViewRepresentable
                .ignoresSafeArea()
                .environmentObject(appSharedModel)
            
            GeometryReader { geometry in
                Rectangle()
                    .background(.ultraThinMaterial)
                    .frame(height: geometry.safeAreaInsets.top)
                    .ignoresSafeArea()
            }
            
            HStack(alignment: .top) {
                airQualityMeasureView
                
                Spacer()
                
                mapToolbarItems
            }
            .padding()
            .padding(.top, 10)
        }
        .overlay(alignment: .bottom) {
            Rectangle()
                .foregroundStyle(.regularMaterial)
                .frame(height: 140)
                .overlay {
                    HStack {
                        ForEach(Layers.allCases, id: \.hashValue) { layer in
                            Label {
                                Text(layer.localizedDescription)
                            } icon: {
                                layer.image
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(appSharedModel.selectedDataLayer.wrappedValue == layer
                                          ? .blue
                                          : Color(uiColor: .lightGray))
                            )
                            .onTapGesture {
                                withAnimation {
                                    appSharedModel.selectedDataLayer.wrappedValue = layer
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .padding(.bottom, 30)
                }
                .offset(y: 40)
        }
        .onAppear {
            MapViewController.LocationsHelper.shared.invokeMapUpdate()
            MapViewController.LocationsHelper.shared.centerMapOnNextUserLocationUpdate()
        }
        .task {
            await getSensors()
        }
        .onChange(of: appSharedModel.isCityLinkedSensorsSheetPresented) {
            if let city = appSharedModel.cityPresented {
                isLinkedCityViewPresented.toggle()
            }
        }
        .sheet(isPresented: $isLinkedCityViewPresented) {
            if let city = appSharedModel.cityPresented {
                linkedView(city: city)
            }
        }
    }
    
    func getSensors() async {
        if let networkSensors = try? await PurpleAirAPI.shared.sensors(), !networkSensors.isEmpty {
            appSharedModel.sensors = networkSensors
        }
    }
    
    func linkedView(city: City) -> some View {
        List {
            Section {
                VStack(alignment: .leading) {
                    HStack {
                        Text(city.reverseGeoCodedData.name)
                            .font(.largeTitle)
                            .bold()
                        
                        Spacer()
                        
                        CloseButtonView(presentationMode: presentationMode) {
                            appSharedModel.isCityLinkedSensorsSheetPresented.toggle()
                        }
                    }
                    
                    Text("\(city.linkedSensors.count) sensors")
                        .font(.title3)
                        .bold()
                    
                    //                    let citySensors = city.linkedSensors
                    //                        .compactMap { sensorId -> Sensor? in
                    //                            if let sensorIndex = appSharedModel.sensors.firstIndex { $0.id == sensorId } {
                    //                                return appSharedModel.sensors[sensorIndex]
                    //                            } else { return nil }
                    //                        }
                    
                    HStack(alignment: .center) {
                        Map(coordinateRegion: .constant(.init(center: city.reverseGeoCodedData.coordinate.toCoreLocationCoordinate(),
                                                              latitudinalMeters: 10_000,
                                                              longitudinalMeters: 10_000)),
                            interactionModes: [],
                            showsUserLocation: true,
                            //                                    annotationItems: citySensors,
                            annotationItems: [city],
                            annotationContent: { city in
                            MapAnnotation(coordinate: city.reverseGeoCodedData.coordinate.toCoreLocationCoordinate()) {
                                CityView(airQuality: city.airQuality, locality: city.reverseGeoCodedData.name)
                            }
                        })
                        .cornerRadius(10)
                        .frame(height: 200)
                    }
                }
            }
            .headerProminence(.increased)
            .listRowBackground(Color(UIColor.systemGroupedBackground))
            .listRowInsets(.init())
            
            ForEach(.constant(city.linkedSensors.sorted(by: <)), id: \.self) { sensorId in
                if let sensorIndex = appSharedModel.sensors.firstIndex { $0.index == sensorId.wrappedValue } {
                    let sensor = appSharedModel.sensors[sensorIndex]
                    
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .soft).impactOccurred(intensity: 1.0)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                            appSharedModel.isCityLinkedSensorsSheetPresented.toggle()
                            appSharedModel.cityPresented = nil
                        }
                    }) {
                        ZStack(alignment: .leading) {
                            HStack(spacing: 15) {
                                SensorDotView(airQuality: sensor.airQuality, overridesAdaptiveColor: true)
                                
                                VStack(alignment: .leading) {
                                    Text(sensor.name)
                                    Text(sensor.airQuality.airQualityCategory.name)
                                        .font(.system(size: 15))
                                        .foregroundColor(Color(sensor.airQuality.airQualityCategory.airQualityColor.adaptiveColor))
                                }
                            }
                            
                            NavigationLink.empty
                        }
                        .foregroundColor(Color(uiColor: UIColor.label))
                        .contextMenu {
                            Button {
                                appSharedModel.cityPresented = nil
                                viewOnMap(sensor: sensor)
                            } label: {
                                Label("Focus Sensor", systemImage: "map")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func viewOnMap(sensor: Sensor) {
        appSharedModel.isCityLinkedSensorsSheetPresented.toggle()
        
        let sensorAnnotation = SensorAnnotation(sensor: sensor, participatesInSpatialAnnotationRendering: false)
        
        MapViewController.LocationsHelper.shared.center(on: .custom(sensor.coordinate.toCoreLocationCoordinate()))
        
        MapViewController.LocationsHelper.shared.mapView.addAnnotation(sensorAnnotation)
        MapViewController.LocationsHelper.shared.mapView.selectAnnotation(sensorAnnotation, animated: false)
    }
    
    var airQualityMeasureView: some View {
        VStack(alignment: .trailing, spacing: 13) {
            Rectangle()
                .background(.regularMaterial)
                .overlay {
                    VStack {
                        Text("AQI pm2.5")
                            .font(.system(size: 9))
                        HStack {
                            Image("AQI Measure")
                            VStack(spacing: 6) {
                                ForEach(AirQualityCategories.all
                                    .map { $0.range.lowerBound }
                                    .filter { $0 != -1 }
                                    .reversed(),
                                        id: \.hashValue)
                                { aqi in
                                    Text("\(aqi)")
                                        .font(.system(size: 9))
                                }
                            }
                        }
                    }
                    .foregroundColor(.white)
                }
                .frame(width: 55, height: 150)
                .cornerRadius(10)
                .onTapGesture {
                    isAirQualityInformationViewPresented.toggle()
                }
                .sheet(isPresented: $isAirQualityInformationViewPresented) {
                    AirQualityInformationView()
                }
        }
    }
    
    var mapToolbarItems: some View {
        VStack(alignment: .trailing, spacing: 13) {
            Button(action: {
                MapViewController.LocationsHelper.shared.center(on: .user)
            }) {
                Image(systemName: "location")
            }
            .buttonStyle(ExploreButtonStyle())
            
            Spacer()
        }
    }
}

struct ExploreButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        Rectangle()
            .background {
                configuration.label
                    .foregroundColor(.blue)
                    .imageScale(.medium)
            }
            .foregroundColor(.white.opacity(0.2))
            .background(.ultraThickMaterial)
            .frame(width: 37, height: 37)
            .cornerRadius(10)
            .shadow(radius: 5)
    }
}

extension City: Identifiable {
    public var id: String {
        reverseGeoCodedData.name
    }
}

extension NavigationLink where Label == EmptyView, Destination == EmptyView {
    
    /// Useful in cases where a `NavigationLink` is needed but there should not be
    /// a destination. e.g. for programmatic navigation.
    static var empty: NavigationLink {
        self.init(destination: EmptyView(), label: { EmptyView() })
    }
}
