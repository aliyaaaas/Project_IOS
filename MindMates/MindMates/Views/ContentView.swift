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

    @State private var currentUserRole = "teacher"
    @State private var currentUserId = "teacher_123"

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
                        currentUserRole: currentUserRole,
                        userRole: currentUserRole
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
