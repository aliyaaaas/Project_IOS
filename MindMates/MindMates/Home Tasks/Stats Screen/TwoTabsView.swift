//
//  TwoTabsView.swift
//  MindMates
//
//  Created by Анастасия on 22.07.2025.
//

import SwiftUI

struct TwoTabsView: View {
    @StateObject var viewModel = ScrollTasksViewModel()
    @State private var selectedTab = 0
    @Namespace private var animationNamespace
    @State private var showNewTask = false
    @StateObject var profileViewModel = ProfileViewModel()
       
    var currentUserRole: Role {
        profileViewModel.role ?? .student
    }
    
    let currentUserId: String

    init(currentUserId: String, viewModel: ScrollTasksViewModel = ScrollTasksViewModel()) {
        self.currentUserId = currentUserId
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.background.opacity(0.7), Color.background.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 8) {
                ButtonView
                
                TopTabView
            }
        }
        .environmentObject(viewModel)
        .onAppear {
            print("Текущая роль: \(profileViewModel.role?.rawValue ?? "nil")")
        }
    }
    
    var ButtonView: some View {
        Group {
            if currentUserRole == .teacher {
                Button {
                    showNewTask = true
                } label: {
                    HStack {
                        Image(systemName: "sparkle")
                        
                        Text("Новое задание")
                    }
                    .padding(6)
                    .background(Color.foreground)
                    .foregroundColor(Color.background)
                    .cornerRadius(7)
                }
                .sheet(isPresented: $showNewTask) {
                    NewTaskView(isPresented: $showNewTask)
                }
            }
        }
    }
    
    var TopTabView: some View {
        VStack {
            TabButtons
            
            ContentTabView
        }
    }
    
    var TabButtons : some View {
        HStack(spacing: 0) {
            ForEach(0..<2) { index in
                Text(index == 0 ? "Текущие" : "Архив")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(selectedTab == index ? Color.foreground : Color.foreground.opacity(0.6))
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(
                        ZStack {
                            if selectedTab == index {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.foreground.opacity(0.1))
                                    .matchedGeometryEffect(id: "tab", in: animationNamespace)
                            }
                        }
                    )
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = index
                        }
                    }
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
    }
    
    var ContentTabView : some View {
        TabView(selection: $selectedTab) {
            
            CurrentTasksView(currentUserId: currentUserId)
                .tag(0)
            
            ArchiveTasksView(currentUserId: currentUserId)
            .tag(1)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(maxHeight: .infinity)
        .padding(10)
    }
}

//struct TwoTabsView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            // Преподаватель
//            TwoTabsView(
//                currentUserRole: .teacher,
//                currentUserId: "teacher_123"
//            )
//            .previewDisplayName("Преподаватель (пустой)")
//            
//            // Студент
//            TwoTabsView(
//                currentUserRole: .student,
//                currentUserId: "student_456"
//            )
//            .previewDisplayName("Студент (пустой)")
//            
//            // С задачами
//            TwoTabsView(
//                currentUserRole: .teacher,
//                currentUserId: "teacher_123"
//            )
//            .previewDisplayName("С задачами")
//        }
//    }
//}
