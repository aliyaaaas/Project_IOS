//
//  NewTaskView.swift
//  MindMates
//
//  Created by Анастасия on 19.07.2025.
//

import SwiftUI

struct NewTaskView: View {
    @Binding var isPresented: Bool
    @StateObject private var viewModel = NewTaskViewModel()
        
    @State private var subject: String = ""
    @State private var description: String = ""
    @State private var deadline: Date = Date()
    @State private var studentEmail: String = ""
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            
            VStack {
                VStack {
                    Text("Добавить новое домашнее задание")
                        .foregroundStyle(Color.foreground)
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    ScrollView {
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Предмет")
                                .font(.title3)
                                .foregroundStyle(Color.secondary)
                                .bold()
                            
                            Picker("Выберите предмет из списка", selection: $subject) {
                                Text("Математика").tag("Математика")
                                Text("Русский").tag("Русский")
                                Text("Физика").tag("Физика")
                                Text("Английский язык").tag("Английский язык")
                                Text("Биология").tag("Биология")
                                Text("Химия").tag("Химия")
                                Text("История").tag("История")
                                Text("География").tag("География")
                                Text("Литература").tag("Литература")
                                Text("Информатика").tag("Информатика")
                            }
                            .pickerStyle(.menu)
                            .tint(Color.foreground)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .overlay {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.white.opacity(0.5))
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.foreground, lineWidth: 2)
                                    }
                                .allowsHitTesting(false)
                            }
                            .contentShape(Rectangle())
                            
                        }
                        .padding(.horizontal, 10)
                        
                        Spacer().frame(height: 20)
                        
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Введите почту ученика")
                                .font(.title3)
                                .foregroundStyle(Color.secondary)
                                .bold()
                            
                            TextEditor(text: $studentEmail)
                                .scrollContentBackground(.hidden)
                                .foregroundColor(Color.foreground)
                                .tint(Color.foreground)
                                .background(Color.white.opacity(0.5))
                                .frame(height: 44)
                                .cornerRadius(5)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.foreground, lineWidth: 2)
                                }
                        }
                        .padding(.horizontal, 10)
                        
                        Spacer().frame(height: 20)
                        
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Введите описание задания или прикрепите ссылку")
                                .font(.title3)
                                .foregroundStyle(Color.secondary)
                                .bold()
                            
                            TextEditor(text: $description)
                                .scrollContentBackground(.hidden)
                                .foregroundColor(Color.foreground)
                                .tint(Color.foreground)
                                .background(Color.white.opacity(0.5))
                                .frame(minHeight: 100)
                                .cornerRadius(5)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.foreground, lineWidth: 2)
                                }
                        }
                        .padding(.horizontal, 10)
                        
                        Spacer().frame(height: 20)
                        
                        VStack (alignment: .leading, spacing: 8) {
                            Text("Дедлайн")
                                .font(.title3)
                                .foregroundStyle(Color.secondary)
                                .bold()
                            
                            DatePicker(
                                "Выберите дату",
                                selection: $deadline,
                                displayedComponents: .date
                            )
                            .datePickerStyle(.graphical)
                            .tint(Color.foreground)
                            .background(Color.white.opacity(0.5))
                            .overlay {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.foreground, lineWidth: 2)
                            }
                        }
                        .padding(.horizontal, 10)
                        
                        Spacer().frame(height: 30)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            Button {
                                createTask()
                            } label: {
                                Text("Создать")
                                    .font(.title3)
                                    .padding()
                                    .background(Color.foreground)
                                    .foregroundColor(Color.background)
                                    .cornerRadius(7)
                            }
                        }
                        
                        Spacer().frame(height: 30)
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width - 40)
            .background(Color.background)
            .cornerRadius(15)
            .shadow(radius: 20)
        }
        .alert("Ошибка", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }
    
    private func createTask() {
        guard !subject.isEmpty, !studentEmail.isEmpty, !description.isEmpty else {
            alertMessage = "Пожалуйста, заполните все поля"
            showAlert = true
            return
        }
            
        isLoading = true
            
        viewModel.createNewTask(
            subject: subject,
            studentEmail: studentEmail,
            description: description,
            deadline: deadline
        ) { result in
            isLoading = false
                
            switch result {
            case .success:
                isPresented = false
            case .failure(let error):
                alertMessage = "Ошибка при создании задания: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }
}

#Preview {
    NewTaskView(isPresented: .constant(true))
}
