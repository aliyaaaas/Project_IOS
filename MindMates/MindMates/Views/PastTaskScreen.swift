//
//  PastTaskScreen.swift
//  MindMates
//
//  Created by BATIK on 20.07.2025.
//
import SwiftUI


struct PastTaskScreen: View {
    @Binding var goToPastTaskScreen: Bool

    @StateObject var viewModel = ScrollClassesViewModel()

    let currentUserId: String
    let currentUserRole: String

    init(
        goToPastTaskScreen: Binding<Bool>,
        currentUserId: String,
        currentUserRole: String
    ) {
        self._goToPastTaskScreen = goToPastTaskScreen
        self.currentUserId = currentUserId
        self.currentUserRole = currentUserRole
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
                        goToPastTaskScreen = false
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

                    Text("Прошедшие занятия")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(darkColor)
                        .offset(y: 70)
                }
                .frame(height: 100)

                // Список прошедших занятий
                ZStack {
                    if completedClasses.isEmpty && !viewModel.isLoading {
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
                .padding(.top, 30)

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

    private var completedClasses: [ClassModel] {
        viewModel.classes.filter { $0.status == .completed || $0.status == .canceled }
    }

    private var EmptyStateView: some View {
        VStack {
            Image(systemName: "archivebox.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(darkColor)
                .padding(8)
                .background(Color.white)
                .clipShape(Circle())
            
            Text("Архив пуст")
                .font(.title2)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    private var ClassListView: some View {
        ScrollView {
            ForEach(completedClasses) { class in
                ClassCellView(class: `class`)
                    .padding(.vertical, 8)
            }
        }
    }
}
