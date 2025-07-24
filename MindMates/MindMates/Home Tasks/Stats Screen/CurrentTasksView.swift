//
//  CurrentTasksView.swift
//  MindMates
//
//  Created by Анастасия on 23.07.2025.
//

import SwiftUI

struct CurrentTasksView: View {
    @EnvironmentObject var viewModel: ScrollTasksViewModel
    let currentUserId: String
    let currentUserRole: String
    
    init(currentUserId: String, currentUserRole: String) {
        self.currentUserId = currentUserId
        self.currentUserRole = currentUserRole
    }
    
    private var filteredTasks: [HomeTask] {
        viewModel.tasks.filter { $0.status == .onCheck || $0.status == .notStarted }
        }
    
    var body: some View {
        ZStack {
            if filteredTasks.isEmpty && !viewModel.isLoading {
                EmptyStateView
            } else {
                TaskListView
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .tint(Color.foreground)
                    .scaleEffect(1.5)
            }
        }
        .alert("Ошибка",
               isPresented: $viewModel.showErrorAlert) {
            Button("Повторить") {
                viewModel.fetchTasks(userId: currentUserId, userRole: currentUserRole)
            }
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
        .onAppear {
                    viewModel.fetchTasks(userId: currentUserId, userRole: currentUserRole)
                }
    }
    
    private var EmptyStateView: some View {
        VStack {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundStyle(Color.foreground)
                .padding(10)
            
            Text("Заданий пока нет")
                .font(.title)
                .bold()
                .foregroundStyle(Color.foreground)
            
        }
    }
    
    private var TaskListView: some View {
        ScrollView {
            ForEach(filteredTasks) { task in
                TaskCellView(task: task)
                    .padding(.vertical, 3)
            }
        }
    }
}

#Preview("С задачами") {
    let mockTasks = [
        HomeTask(
            id: "1",
            subject: "Математика",
            teacherId: "teacher1",
            studentId: "student1",
            description: "Решить задачи 1-10",
            deadline: Date().addingTimeInterval(86400),
            status: .notStarted,
            files: nil,
            teachersComment: nil
        ),
        HomeTask(
            id: "2",
            subject: "Физика",
            teacherId: "teacher2",
            studentId: "student1",
            description: "Лабораторная работа",
            deadline: Date().addingTimeInterval(172800),
            status: .onCheck,
            files: ["doc1.pdf"],
            teachersComment: nil
        )
    ]
    
    let mockVM = ScrollTasksViewModel(mockTasks: mockTasks, isLoading: false)
    
    return CurrentTasksView(currentUserId: "user123", currentUserRole: "student")
        .environmentObject(mockVM)
}

#Preview("Пустой список") {
    let mockVM = ScrollTasksViewModel(mockTasks: [], isLoading: false)
    return CurrentTasksView(currentUserId: "user123", currentUserRole: "student")
        .environmentObject(mockVM)
}

#Preview("Загрузка") {
    let mockVM = ScrollTasksViewModel(mockTasks: [], isLoading: true)
    return CurrentTasksView(currentUserId: "user123", currentUserRole: "student")
        .environmentObject(mockVM)
}
