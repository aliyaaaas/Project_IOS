//
//  FutureClassScreen.swift
//  MindMates
//
//  Created by BATIK on 20.07.2025.
//


import SwiftUI

struct FutureClassScreen: View {
    @Binding var goToFutureClassScreen: Bool

    @StateObject var viewModel = ScrollClassesViewModel()

    let currentUserId: String
    let currentUserRole: String
    let userRole: String // "teacher" или "student"

    @State private var showNewClass = false

    init(
        goToFutureClassScreen: Binding<Bool>,
        currentUserId: String,
        currentUserRole: String,
        userRole: String = "student"
    ) {
        self._goToFutureClassScreen = goToFutureClassScreen
        self.currentUserId = currentUserId
        self.currentUserRole = currentUserRole
        self.userRole = userRole
    }

    let lightColor = Color(red: 245/255, green: 233/255, blue: 209/255)
    let darkColor = Color(red: 148/255, green: 144/255, blue: 115/255)

    var body: some View {
        ZStack {
            lightColor.edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                ZStack {
                    darkColor
                        .frame(height: 100)
                        .edgesIgnoringSafeArea(.top)

                    Text("MindMates")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .opacity(0.4)
                        .offset(y: -30)

                    Button(action: {
                        goToFutureClassScreen = false
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .bold))
                            Text("Назад")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .medium))
                        }
                        .padding(.leading, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .offset(y: -30)

                    Text("Будущие занятия")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(darkColor)
                        .offset(y: 130)
                }
                .frame(height: 100)

                if userRole == "teacher" {
                    Button {
                        showNewClass = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Новое занятие")
                        }
                        .padding(6)
                        .background(darkColor)
                        .foregroundColor(.white)
                        .cornerRadius(7)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, -40)
                    .sheet(isPresented: $showNewClass) {
                        NewClassView(
                            isPresented: $showNewClass,
                            teacherId: currentUserId
                        ) { newClass in
                            ClassDatabaseService().addClass(newClass) { result in
                                DispatchQueue.main.async {
                                    if case .success = result {
                                        viewModel.fetchClasses(userId: currentUserId, userRole: currentUserRole)
                                    }
                                }
                            }
                        }
                    }
                }

                // Список занятий
                ZStack {
                    if currentClasses.isEmpty && !viewModel.isLoading {
                        EmptyStateView
                    } else {
                        ClassListView
                    }

                    if viewModel.isLoading {
                        ProgressView()
                            .tint(darkColor)
                            .scaleEffect(1.5)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.top, 120)

                Spacer()
            }
        }
        .onAppear {
            viewModel.fetchClasses(userId: currentUserId, userRole: currentUserRole)
        }
        .alert("Ошибка", isPresented: $viewModel.showErrorAlert) {
            Button("Повторить") {
                viewModel.fetchClasses(userId: currentUserId, userRole: currentUserRole)
            }
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
    }

    private var currentClasses: [ClassModel] {
        viewModel.classes.filter { $0.status == .upcoming }
    }

    private var EmptyStateView: some View {
        VStack {
            Image(systemName: "calendar.badge.clock")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(darkColor)
                .padding(8)
                .background(Color.white)
                .clipShape(Circle())

            Text("Занятий пока нет")
                .font(.title2)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    private var ClassListView: some View {
        ScrollView {
            ForEach(currentClasses) { _class in
                ClassCellView(_class: _class)
                    .padding(.vertical, 8)
            }
        }
    }
}





struct FutureClassScreen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FutureClassScreen(
                goToFutureClassScreen: .constant(false),
                currentUserId: "teacher_123",
                currentUserRole: "teacher",
                userRole: "teacher"
            )
            .previewDisplayName("Преподаватель")
            .previewDevice("iPhone 15")

            FutureClassScreen(
                goToFutureClassScreen: .constant(false),
                currentUserId: "student_456",
                currentUserRole: "student",
                userRole: "student"
            )
            .previewDisplayName("Студент")
            .previewDevice("iPhone 15")

            FutureClassScreen(
                goToFutureClassScreen: .constant(false),
                currentUserId: "teacher_123",
                currentUserRole: "teacher",
                userRole: "teacher"
            )
            .environmentObject(
                ScrollClassesViewModel(mockClasses: [
                    ClassModel(
                        id: "1",
                        title: "Математика",
                        teacherId: "teacher_123",
                        studentId: "student_456",
                        description: "Решение квадратных уравнений",
                        date: Date().addingTimeInterval(3600 * 2),
                        status: .upcoming,
                        materials: ["slides.pdf"],
                        teacherComment: nil
                    ),
                    ClassModel(
                        id: "2",
                        title: "Физика",
                        teacherId: "teacher_123",
                        studentId: "student_456",
                        description: "Лабораторная работа по физике",
                        date: Date().addingTimeInterval(3600 * 5),
                        status: .upcoming,
                        materials: nil,
                        teacherComment: nil
                    )
                ])
            )
            .previewDisplayName("С занятиями")
        }
    }
}
