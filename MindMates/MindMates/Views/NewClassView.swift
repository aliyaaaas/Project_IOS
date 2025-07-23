//
//  NewClassView.swift
//  MindMates
//
//  Created by BATIK on 23.07.2025.
//

import SwiftUI

struct NewClassView: View {
    @Binding var isPresented: Bool
    let teacherId: String
    let onSave: (ClassModel) -> Void

    @State private var title: String = ""
    @State private var studentId: String = ""
    @State private var description: String = ""
    @State private var date: Date = Date().addingTimeInterval(3600) // +1 час
    @State private var studentEmail: String = ""
    @State private var materials: [String] = []

    var body: some View {
        ZStack {
            VStack {
                VStack {
                    Text("Добавить новое занятие")
                        .foregroundStyle(Color.foreground)
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding()

                    ScrollView {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Название занятия")
                                .font(.title3)
                                .foregroundStyle(Color.secondary)
                                .bold()

                            TextField("Например: Математика", text: $title)
                                .padding(10)
                                .background(Color.white.opacity(0.5))
                                .cornerRadius(5)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.foreground, lineWidth: 2)
                                }
                        }
                        .padding(.horizontal, 10)

                        Spacer().frame(height: 20)

                        VStack(alignment: .leading, spacing: 8) {
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

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Описание занятия")
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

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Дата и время")
                                .font(.title3)
                                .foregroundStyle(Color.secondary)
                                .bold()

                            DatePicker(
                                "Выберите дату и время",
                                selection: $date,
                                displayedComponents: [.date, .hourAndMinute]
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

                        HStack {
                            Button("Отмена") {
                                isPresented = false
                            }
                            .foregroundColor(Color.foreground)

                            Button("Создать") {
                                // Создаём объект занятия
                                let newClass = ClassModel(
                                    id: nil,
                                    title: title,
                                    teacherId: teacherId,
                                    studentId: studentId,
                                    description: description,
                                    date: date,
                                    status: .upcoming,
                                    materials: materials.isEmpty ? nil : materials,
                                    teacherComment: nil
                                )

                                onSave(newClass)
                                isPresented = false
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(Color.foreground)
                            .foregroundColor(Color.background)
                            .cornerRadius(8)
                        }
                        .padding(.top, 20)
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width - 40)
            .background(Color.background)
            .cornerRadius(15)
            .shadow(radius: 20)
        }
    }
}

#Preview {
    NewClassView(
        isPresented: .constant(true),
        teacherId: "teacher_123"
    ) { _ in }
}
