//
//  BreatheFreeApp.swift
//  BreatheFree
//
//  Created by Admin on 10/13/23.
//

import SwiftUI
import Combine

import BreatheShared
import BreatheLogic

@main
struct BreatheApp: App {
    @StateObject private var appSharedModel  = AppSharedModel()
    @StateObject private var favoritesHelper = FavoritesHelper()
    
    @State private var cancellables = Set<AnyCancellable>()
    
    init() {
        EnvironmentVariables.shared.path = Bundle.main.path(forResource: "", ofType: "env")!
        EnvironmentVariables.shared.load()
        
        let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        UITabBar.appearance().standardAppearance = tabBarAppearance
        
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appSharedModel)
                .environmentObject(favoritesHelper)
                .onAppear {
                    appSharedModel.$sensors
                        .dropFirst()
                        .sink { sensors in
                            cancellables = []
                            favoritesHelper.sensors = sensors
                            favoritesHelper.loadSensors()
                        }.store(in: &cancellables)
                    
                    appSharedModel.$cities
                        .dropFirst()
                        .sink { cities in
                            cancellables = []
                            favoritesHelper.cities = cities
                            favoritesHelper.loadCities()
                        }.store(in: &cancellables)
                }
        }
    }
}
