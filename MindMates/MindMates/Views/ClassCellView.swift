//
//  ClassCellView.swift
//  MindMates
//
//  Created by BATIK on 23.07.2025.
//


import SwiftUI

struct ClassCellView: View {
    let _class: ClassModel // Используем _class вместо class
    @State private var showFullInfo = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.background.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.foreground, lineWidth: 2)
                )
            
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(_class.title)
                        .font(.title2)
                        .bold()
                        .foregroundStyle(Color.foreground)
                        .foregroundStyle(Color.foreground)
                    
                    Text(_class.teacherId) // здесь можно будет подставить имя из базы
                        .foregroundStyle(Color.foreground)
                    
                    HStack {
                        Text("Дата: ")
                            .foregroundStyle(Color.foreground)
                            .bold()
                        
                        Text(_class.date.formatted(
                            .dateTime
                                .locale(Locale(identifier: "ru_RU"))
                                .day().month(.abbreviated).year().hour().minute()
                        ))
                        .foregroundStyle(Color.foreground)
                    }
                }
                
                VStack {
                    Text(_class.status.rawValue)
                        .font(.system(size: 12, weight: .semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.foreground.opacity(0.9))
                        .foregroundColor(Color.background)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    
                    Spacer()
                }
                .padding(15)
            }
        }
        .frame(height: 100)
        .padding(.horizontal, 10)
        .contentShape(Rectangle())
        .onTapGesture {
            showFullInfo = true
        }
        .sheet(isPresented: $showFullInfo) {
            FullClassInfoView(
                isPresented: $showFullInfo,
                _class: _class // Передаём _class
            )
        }
    }
}

// MARK: - Preview
#Preview("Предстоящее занятие") {
    let testClass = ClassModel(
        id: "1",
        title: "Математика",
        teacherId: "Преподаватель Сидоров",
        studentId: "student_456",
        description: "Решение квадратных уравнений",
        date: Date().addingTimeInterval(3600 * 3), // +3 часа
        status: .upcoming,
        materials: ["slides.pdf"],
        teacherComment: nil
    )
    
    struct PreviewWrapper: View {
        let _class: ClassModel
        
        var body: some View {
            ClassCellView(_class: _class)
        }
    }
    
    return PreviewWrapper(_class: testClass)
}

#Preview("Завершённое занятие") {
    let testClass = ClassModel(
        id: "2",
        title: "Физика",
        teacherId: "Преподаватель Козлов",
        studentId: "student_456",
        description: "Лабораторная работа по оптике",
        date: Date().addingTimeInterval(-86400), // вчера
        status: .completed,
        materials: ["report.pdf"],
        teacherComment: "Хорошо выполнено!"
    )
    
    struct PreviewWrapper: View {
        let _class: ClassModel
        
        var body: some View {
            ClassCellView(_class: _class)
        }
    }
    
    return PreviewWrapper(_class: testClass)
}
