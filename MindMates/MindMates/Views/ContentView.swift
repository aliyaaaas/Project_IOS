//
//  ContentView.swift
//  MindMates
//
//  Created by Анастасия on 19.07.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var goToPastTaskScreen = false
    @State private var goToFutureClassScreen = false

    var body: some View {
        NavigationView {
            ZStack {
                if goToPastTaskScreen {
                    PastTaskScreen(goToPastTaskScreen: $goToPastTaskScreen)
                        .navigationBarHidden(true)
                } else if goToFutureClassScreen {
                    FutureClassScreen(goToFutureClassScreen: $goToFutureClassScreen)
                        .navigationBarHidden(true)
                }else {
                    ClassesScreen(goToPastTaskScreen: $goToPastTaskScreen, goToFutureClassScreen: $goToFutureClassScreen)
                        .navigationBarHidden(true)
                }
            }
        }
    }
}
#Preview {
    ContentView()
}
