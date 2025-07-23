//
//  FullClassInfoView.swift
//  MindMates
//
//  Created by BATIK on 23.07.2025.
//


import SwiftUI

struct FullClassInfoView: View {
    @Binding var isPresented: Bool
    let _class: ClassModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Group {
                        Text("Название")
                            .font(.headline)
                            .foregroundStyle(Color.foreground)
                        
                        Text(_class.title)
                            .font(.title2)
                            .bold()
                            .foregroundStyle(Color.foreground)
                    }
                    
                    Divider()
                    
                    Group {
                        Text("Преподаватель")
                            .font(.headline)
                            .foregroundStyle(Color.foreground)
                        
                        Text(_class.teacherId)
                            .foregroundStyle(Color.foreground)
                    }
                    
                    Divider()
                    
                    Group {
                        Text("Дата и время")
                            .font(.headline)
                            .foregroundStyle(Color.foreground)
                        
                        Text(_class.date.formatted(
                            .dateTime
                                .locale(Locale(identifier: "ru_RU"))
                                .day().month(.wide).year().weekday(.wide).hour().minute()
                        ))
                        .foregroundStyle(Color.foreground)
                    }
                    
                    Divider()
                    
                    Group {
                        Text("Описание")
                            .font(.headline)
                            .foregroundStyle(Color.foreground)
                        
                        Text(_class.description)
                            .foregroundStyle(Color.foreground)
                    }
                    
                    if let materials = _class.materials, !materials.isEmpty {
                        Divider()
                        
                        Group {
                            Text("Материалы")
                                .font(.headline)
                                .foregroundStyle(Color.foreground)
                            
                            ForEach(materials, id: \.self) { file in
                                HStack {
                                    Image(systemName: "doc.text")
                                        .foregroundColor(Color.foreground)
                                    
                                    Text(file)
                                        .foregroundStyle(Color.foreground)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "arrow.down.circle")
                                        .foregroundColor(Color.foreground)
                                }
                                .padding(.vertical, 2)
                            }
                        }
                    }
                    
                    if let comment = _class.teacherComment {
                        Divider()
                        
                        Group {
                            Text("Комментарий преподавателя")
                                .font(.headline)
                                .foregroundStyle(Color.foreground)
                            
                            Text(comment)
                                .foregroundStyle(Color.foreground)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Информация о занятии")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Закрыть") {
                        isPresented = false
                    }
                }
            }
            .background(Color.background)
        }
    }
}

#Preview {
    let testClass = ClassModel(
        id: "1",
        title: "Математика",
        teacherId: "Преподаватель Сидоров",
        studentId: "student_456",
        description: "Решение квадратных уравнений. Необходимо выполнить все номера из учебника.",
        date: Date().addingTimeInterval(3600 * 3),
        status: .upcoming,
        materials: ["slides.pdf", "homework.docx"],
        teacherComment: "Не забудьте проверить дискриминант!"
    )
    
    return FullClassInfoView(
        isPresented: .constant(true),
        _class: testClass
    )
}
