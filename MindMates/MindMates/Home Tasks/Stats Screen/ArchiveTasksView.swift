//
//  ArchiveTasksView.swift
//  MindMates
//
//  Created by Анастасия on 23.07.2025.
//

import SwiftUI

struct ArchiveTasksView: View {
    @StateObject var viewModel = ScrollTasksViewModel()
    @StateObject var profileViewModel = ProfileViewModel()
    let currentUserId: String

    var currentUserRole: Role {
        profileViewModel.role ?? .student
    }
    
    init(currentUserId: String) {
        self.currentUserId = currentUserId
    }
    
    private var filteredTasks: [HomeTask] {
            viewModel.tasks.filter { $0.status == .checked }
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

//#Preview("Преподаватель с задачами") {
//    let mockTasks = [
//        HomeTask(
//            id: "1",
//            subject: "Математика",
//            teacherId: "teacher1",
//            studentId: "student1",
//            description: "Решить задачи 1-10",
//            deadline: Date().addingTimeInterval(86400),
//            status: .notStarted,
//            files: nil,
//            teachersComment: nil
//        ),
//        HomeTask(
//            id: "2",
//            subject: "Физика",
//            teacherId: "teacher2",
//            studentId: "student1",
//            description: "Лабораторная работа",
//            deadline: Date().addingTimeInterval(172800),
//            status: .checked,
//            files: ["doc1.pdf"],
//            teachersComment: "Отлично!"
//        ),
//        HomeTask(
//            id: "3",
//            subject: "Химия",
//            teacherId: "teacher1",
//            studentId: "student2",
//            description: "Подготовить отчет",
//            deadline: Date().addingTimeInterval(259200),
//            status: .onCheck,
//            files: ["report.docx"],
//            teachersComment: nil
//        )
//    ]
//    
//    let mockVM = ScrollTasksViewModel(mockTasks: mockTasks, isLoading: false)
//    
//    return TwoTabsView(
//        userRole: Role.teacher,
//        currentUserRole: "teacher",
//        currentUserId: "teacher_123"
//    )
//    .environmentObject(mockVM)
//}
//
//#Preview("Преподаватель с архивными задачами") {
//    let mockTasks = [
//        HomeTask(
//            id: "1",
//            subject: "Математика",
//            teacherId: "teacher1",
//            studentId: "student1",
//            description: "Решить задачи 1-10",
//            deadline: Date().addingTimeInterval(86400),
//            status: .checked, // Важно: только завершенные задачи для архива
//            files: nil,
//            teachersComment: "Хорошая работа"
//        ),
//        HomeTask(
//            id: "2",
//            subject: "Физика",
//            teacherId: "teacher2",
//            studentId: "student1",
//            description: "Лабораторная работа",
//            deadline: Date().addingTimeInterval(172800),
//            status: .checked, // Важно: только завершенные задачи для архива
//            files: ["doc1.pdf"],
//            teachersComment: "Отлично!"
//        )
//    ]
//    
//    let mockVM = ScrollTasksViewModel(mockTasks: mockTasks, isLoading: false)
//    
//    return ArchiveTasksView(
//        currentUserId: "teacher_123",
//        currentUserRole: Role.teacher,
//        viewModel: mockVM
//    )
//}
//
//#Preview("Студент с архивными задачами") {
//    let mockTasks = [
//        HomeTask(
//            id: "3",
//            subject: "История",
//            teacherId: "teacher3",
//            studentId: "student_456",
//            description: "Написать эссе",
//            deadline: Date().addingTimeInterval(259200),
//            status: .checked, // Важно: только завершенные задачи для архива
//            files: ["essay.pdf"],
//            teachersComment: "Принято"
//        )
//    ]
//    
//    let mockVM = ScrollTasksViewModel(mockTasks: mockTasks, isLoading: false)
//    
//    return ArchiveTasksView(
//        currentUserId: "student_456",
//        currentUserRole: Role.student,
//        viewModel: mockVM
//    )
//}
//
//#Preview("Пустой архив") {
//    let mockVM = ScrollTasksViewModel(mockTasks: [], isLoading: false)
//    return ArchiveTasksView(
//        currentUserId: "teacher_123",
//        currentUserRole: Role.teacher,
//        viewModel: mockVM
//    )
//}
//
//#Preview("Загрузка архива") {
//    let mockVM = ScrollTasksViewModel(mockTasks: [], isLoading: true)
//    return ArchiveTasksView(
//        currentUserId: "student_456",
//        currentUserRole: Role.student,
//        viewModel: mockVM
//    )
//}
