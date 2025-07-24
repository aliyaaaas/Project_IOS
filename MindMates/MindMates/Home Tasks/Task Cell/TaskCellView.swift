//
//  TaskCellView.swift
//  MindMates
//
//  Created by Анастасия on 19.07.2025.
//

import SwiftUI

struct TaskCellView: View {
    let task : HomeTask
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
                VStack (alignment: .leading, spacing: 5) {
                    Text(task.subject)
                        .font(.title2)
                        .bold()
                        .foregroundStyle(Color.foreground)
                    
                    Text(task.teacherId) // тут надо по айди получать имя
                        .foregroundStyle(Color.foreground)
                    
                    HStack {
                        Text("Дедлайн: ")
                            .foregroundStyle(Color.foreground)
                            .bold()
                        
                        Text(task.deadline.formatted(
                            .dateTime
                                .locale(Locale(identifier: "ru_RU"))
                                .day().month(.abbreviated).year())
                        )
                        .foregroundStyle(Color.foreground)
                    }
                }
                
                VStack {
                    Text("\(task.status.rawValue)")
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
        .onTapGesture{
            showFullInfo = true
        }
        .sheet(isPresented: $showFullInfo) {
            FullTaskInfoView(
                isPresented: $showFullInfo,
                task: task
            )
        }
    }
}

#Preview("Проверенная задача") {
    let testTask = HomeTask(
        id: "3",
        subject: "Программирование",
        teacherId: "Преподаватель Петров",
        studentId: "Студент Иванова",
        description: "Разработать приложение на SwiftUI",
        deadline: Date().addingTimeInterval(86400 * 7), 
        status: .checked,
        files: ["project.zip"],
        teachersComment: "Отличная работа! Есть небольшие замечания по архитектуре."
    )
    
    struct PreviewWrapper: View {
        let task: HomeTask
        
        var body: some View {
            TaskCellView(
                task: task
            )
        }
    }
    
    return PreviewWrapper(task: testTask)
}
