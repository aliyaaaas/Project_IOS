//
//  MainTabView.swift
//  MindMates
//
//  Created by Анастасия on 23.07.2025.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .profile
    @StateObject private var profileViewModel = ProfileViewModel()
    
    let lightColor = Color(red: 245/255, green: 233/255, blue: 209/255)
    let darkColor = Color(red: 148/255, green: 144/255, blue: 115/255)
    let accentColor = Color(red: 168/255, green: 158/255, blue: 50/255)
    
    @Namespace private var animation
    
    enum Tab: String, CaseIterable {
        case lessons = "calendar"
        case tasks = "book.fill"
        case profile = "person.fill"
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                ContentView()
                    .tag(Tab.lessons)
                    .tabItem {
                        Label("", systemImage: Tab.lessons.rawValue)
                    }
                
                TwoTabsView(
                    currentUserId: profileViewModel.uid ?? "default_user_id"
                )
                    .tag(Tab.tasks)
                    .tabItem {
                        Label("", systemImage: Tab.tasks.rawValue)
                    }
                
                ProfileScreen()
                    .tag(Tab.profile)
                    .tabItem {
                        Label("", systemImage: Tab.profile.rawValue)
                    }
            }
            .tint(darkColor)
            .overlay(
                VStack {
                    Spacer()
                    HStack {
                        ForEach(Tab.allCases, id: \.self) { tab in
                            Spacer()
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                                    selectedTab = tab
                                }
                            } label: {
                                Image(systemName: tab.rawValue)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .scaleEffect(selectedTab == tab ? 1.2 : 1.0)
                                    .foregroundColor(selectedTab == tab ? darkColor : darkColor.opacity(0.6))
                                    .matchedGeometryEffect(id: tab.rawValue, in: animation)
                            }
                            Spacer()
                        }
                    }
                    .frame(height: 60)
                    .background(
                        lightColor.opacity(0.9)
                            .shadow(color: darkColor.opacity(0.3), radius: 3, x: 0, y: -5)
                            .edgesIgnoringSafeArea(.bottom)
                    )
                }
            )
        }
        .onAppear {
            UITabBar.appearance().isHidden = true
        }
    }
}

#Preview {
    MainTabView()
}
