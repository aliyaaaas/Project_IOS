//
//  ContentView.swift
//  MindMates
//
//  Created by Анастасия on 19.07.2025.
//

import SwiftUI

// В ContentView.swift
struct ContentView: View {
    @State private var goToPastTaskScreen = false
    @State private var goToFutureClassScreen = false

    @State private var currentUserRole = "teacher" // или получи из Auth
    @State private var currentUserId = "user_123"  // или из Firebase

    var body: some View {
        NavigationView {
            ZStack {
                if goToPastTaskScreen {
                    PastTaskScreen(
                        goToPastTaskScreen: $goToPastTaskScreen,
                        currentUserId: currentUserId,
                        currentUserRole: currentUserRole
                    )
                    .navigationBarHidden(true)
                } else if goToFutureClassScreen {
                    FutureClassScreen(
                        goToFutureClassScreen: $goToFutureClassScreen,
                        currentUserId: currentUserId,
                        currentUserRole: currentUserRole
                    )
                    .navigationBarHidden(true)
                } else {
                    ClassesScreen(
                        goToPastTaskScreen: $goToPastTaskScreen,
                        goToFutureClassScreen: $goToFutureClassScreen
                    )
                    .navigationBarHidden(true)
                }
            }
        }
    }
}
#Preview {
    ContentView()
}
