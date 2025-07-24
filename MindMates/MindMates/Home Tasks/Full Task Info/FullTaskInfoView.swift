//
//  FullTaskInfoView.swift
//  MindMates
//
//  Created by Анастасия on 20.07.2025.
//

import SwiftUI
import FirebaseAuth

struct FullTaskInfoView: View {
    @Binding var isPresented: Bool
    let task: HomeTask
    @State private var taskStatus: TaskStatus
    @State private var userRole: Role?
    @StateObject private var viewModel: FullTaskInfoViewModel
    @State private var showDocumentPicker = false
    @State private var comment: String = ""
        
    init(isPresented: Binding<Bool>, task: HomeTask) {
        self._isPresented = isPresented
        self.task = task
        self._taskStatus = State(initialValue: task.status)
        self._viewModel = StateObject(wrappedValue: FullTaskInfoViewModel(task: task))
    }
        
    var body: some View {
        ZStack {
            backgroundView
            
            mainContentView
        }
        .task {
            await loadUserRole()
        }
    }
    
    private func loadUserRole() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        do {
            userRole = try await FirebaseStorage.shared.getUserRole(uid: uid)
        } catch {
            print("Ошибка загрузки роли: \(error)")
        }
    }
    
    private var formattedDeadline: String {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.dateFormat = "dd MMM yyyy"
            return formatter.string(from: task.deadline)
        }
    
    private var backgroundView: some View {
        Color.black.opacity(0)
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                isPresented = false
            }
    }
    
    private var mainContentView: some View {
        VStack (spacing: 0) {
            headerView
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.foreground)
                .padding(5)
                
            ScrollView {
                Text("Описание")
                    .foregroundStyle(Color.foreground)
                    .bold()
                    .padding(.top, 10)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.white.opacity(0.5))
                    
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.foreground, lineWidth: 2)
                    
                    Text(task.description)
                        .foregroundStyle(Color.foreground)
                        .frame(maxWidth: .infinity)
                        .padding(5)
                }
                .padding(.horizontal, 10)
            
                Text("Документы")
                    .foregroundColor(Color.foreground)
                    .bold()
                    .padding(.top, 10)
                
                ForEach(viewModel.attachedDocuments, id: \.self) { url in
                    HStack {
                        Image(systemName: "doc.fill")
                            .foregroundStyle(Color.foreground)
                        
                        Text(url.lastPathComponent)
                            .foregroundStyle(Color.foreground)
                            .lineLimit(1)
                                                
                        Spacer()
                                            
                        Button {
                            viewModel.attachedDocuments.removeAll { $0 == url }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color.foreground)
                        }
                    }
                    .padding(.horizontal, 5)
                }
                
                if taskStatus == TaskStatus.notStarted {
                    VStack (alignment: .leading) {
                        
                        Button(action: {
                            showDocumentPicker = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Добавить документы")
                            }
                            .foregroundColor(Color.foreground)
                            .padding()
                            .background(Color.background)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.foreground, lineWidth: 1)
                            )
                        }
                        .padding(.horizontal, 10)
                        .padding(.top, 5)
                        
                        if !viewModel.attachedDocuments.isEmpty {
                            HStack {
                                Spacer()
                                
                                Button(action: {
                                    let updatedTask = HomeTask(
                                        id: task.id,
                                        subject: task.subject,
                                        teacherId: task.teacherId,
                                        studentId: task.studentId,
                                        description: task.description,
                                        deadline: task.deadline,
                                        status: TaskStatus.onCheck,
                                        files: viewModel.attachedDocuments.map { $0.absoluteString },
                                        teachersComment: nil
                                    )
                                    
                                    viewModel.sendTask(updatedTask: updatedTask) { success in
                                        if success {
                                            isPresented = false
                                        }
                                    }
                                }) {
                                    Text("Отправить на проверку")
                                        .foregroundColor(Color.background)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                        .background(Color.foreground)
                                        .cornerRadius(8)
                                }
                                
                                Spacer()
                            }
                            .padding(.top, 10)
                        }
                    }
                } else if taskStatus == TaskStatus.onCheck {
                    if userRole == Role.teacher {
                        Text("Комментарий")
                            .foregroundStyle(Color.foreground)
                            .bold()
                            .padding(.top, 10)
                        
                        TextEditor(text: $comment)
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
                            .padding(.horizontal, 10)
                        
                        if !comment.isEmpty {
                            Button  {
                                let updatedTask = HomeTask(
                                    id: task.id,
                                    subject: task.subject,
                                    teacherId: task.teacherId,
                                    studentId: task.studentId,
                                    description: task.description,
                                    deadline: task.deadline,
                                    status: TaskStatus.checked,
                                    files: task.files,
                                    teachersComment: comment
                                )
                                
                                viewModel.sendTask(updatedTask: updatedTask) { success in
                                    if success {
                                        isPresented = false
                                    }
                                }
                            } label: {
                                Text("Отправить")
                                    .foregroundColor(Color.background)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(Color.foreground)
                                    .cornerRadius(8)
                            }
                        }
                    }
                } else if taskStatus == TaskStatus.checked {
                    Text("Комментарий")
                        .foregroundStyle(Color.foreground)
                        .bold()
                        .padding(.top, 10)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white.opacity(0.5))
                        
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.foreground, lineWidth: 2)
                        
                        Text(task.teachersComment ?? "Комментарий отсутствует")
                            .foregroundStyle(Color.foreground)
                            .frame(maxWidth: .infinity)
                            .padding(5)
                    }
                    .padding(.horizontal, 10)
                    
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width - 40)
        .background(Color.background)
        .cornerRadius(15)
        .shadow(radius: 20)
        .sheet(isPresented: $showDocumentPicker) {
            DocumentPicker(urls: $viewModel.attachedDocuments)
        }
    }
    
    private var headerView: some View {
        VStack {
            HStack (alignment: .top) {
                VStack (alignment: .leading, spacing: 8) {
                    Text(task.subject)
                        .font(.title2)
                        .bold()
                        .foregroundStyle(Color.foreground)
                        .lineLimit(1)
                        .padding(.top, 10)
                    
                    Text(userRole == Role.teacher ? task.studentId : task.teacherId) 
                        .foregroundStyle(Color.foreground)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    
                    HStack {
                        Text("Дедлайн:")
                            .foregroundStyle(Color.foreground)
                            .bold()
                        
                        Text(formattedDeadline)
                        .foregroundStyle(Color.foreground)

                    }
                }
                
                
                Spacer()
                
                VStack (alignment: .trailing){
                    Text("\(task.status.rawValue)")
                        .font(.system(size: 12, weight: .semibold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.foreground.opacity(0.9))
                            .foregroundColor(Color.background)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    
                    
                }
                .padding(15)
            }
            .padding(.horizontal)
        }
        .frame(height: 120)
        .background(Color.background)
    }
}

#Preview {
    let testTask = HomeTask(
        id: "1",
        subject: "Математика",
        teacherId: "Преподаватель Иванов",
        studentId: "Студент Петров",
        description: "Решить задачи по линейной алгебре: №1-10 из учебника",
        deadline: Date().addingTimeInterval(86400 * 3), // +3 дня
        status: .notStarted,
        files: [],
        teachersComment: nil
    )
    
    @State var isPresented = true
    
    return FullTaskInfoView(
        isPresented: $isPresented,
        task: testTask
    )
    .previewDisplayName("Стандартный вид")
}

#Preview("Задача на проверке") {
    let testTask = HomeTask(
        id: "2",
        subject: "Физика",
        teacherId: "Преподаватель Сидоров",
        studentId: "Студент Козлов",
        description: "Лабораторная работа №3 по термодинамике",
        deadline: Date().addingTimeInterval(-86400), // Вчера
        status: .onCheck,
        files: ["file:///doc1.pdf", "file:///doc2.docx"],
        teachersComment: nil
    )
    
    struct PreviewWrapper: View {
            @State private var isPresented = true
            let task: HomeTask
            
            var body: some View {
                FullTaskInfoView(
                    isPresented: $isPresented,
                    task: task
                )
                .onAppear {
                    let viewModel = FullTaskInfoViewModel(task: task)
                    viewModel.attachedDocuments = [
                        URL(string: "file:///doc1.pdf")!,
                        URL(string: "file:///doc2.docx")!
                    ]
                }
            }
        }
        
        return PreviewWrapper(task: testTask)

}

#Preview {
    let testTask = HomeTask(
        id: "1",
        subject: "Математика",
        teacherId: "Преподаватель Иванов",
        studentId: "Студент Петров",
        description: "Решить задачи по линейной алгебре: №1-10 из учебника",
        deadline: Date().addingTimeInterval(86400 * 3), // +3 дня
        status: .notStarted,
        files: [],
        teachersComment: nil
    )
    
    struct PreviewWrapper: View {
        @State private var isPresented = true
        let task: HomeTask
        
        var body: some View {
            FullTaskInfoView(
                isPresented: $isPresented,
                task: task
            )
        }
    }
    
    return PreviewWrapper(task: testTask)
}

#Preview("Задача на проверке") {
    let testTask = HomeTask(
        id: "2",
        subject: "Физика",
        teacherId: "Преподаватель Сидоров",
        studentId: "Студент Козлов",
        description: "Лабораторная работа №3 по термодинамике",
        deadline: Date().addingTimeInterval(-86400), // Вчера
        status: .onCheck,
        files: ["doc1.pdf", "doc2.docx"],
        teachersComment: nil
    )
    
    struct PreviewWrapper: View {
        @State private var isPresented = true
        let task: HomeTask
        
        var body: some View {
            FullTaskInfoView(
                isPresented: $isPresented,
                task: task
            )
        }
    }
    
    return PreviewWrapper(task: testTask)
}

#Preview("Проверенная задача") {
    let testTask = HomeTask(
        id: "3",
        subject: "Программирование",
        teacherId: "Преподаватель Петров",
        studentId: "Студент Иванова",
        description: "Разработать приложение на SwiftUI",
        deadline: Date().addingTimeInterval(-86400 * 7), // Неделю назад
        status: .checked,
        files: ["project.zip"],
        teachersComment: "Отличная работа! Есть небольшие замечания по архитектуре."
    )
    
    struct PreviewWrapper: View {
        @State private var isPresented = true
        let task: HomeTask
        
        var body: some View {
            FullTaskInfoView(
                isPresented: $isPresented,
                task: task
            )
        }
    }
    
    return PreviewWrapper(task: testTask)
}

#Preview("Для преподавателя") {
    let testTask = HomeTask(
        id: "4",
        subject: "Базы данных",
        teacherId: "Преподаватель Смирнов",
        studentId: "Студент Кузнецов",
        description: "Спроектировать схему БД для интернет-магазина",
        deadline: Date().addingTimeInterval(86400 * 2), // +2 дня
        status: .onCheck,
        files: ["database_design.pdf"],
        teachersComment: nil
    )
    
    struct PreviewWrapper: View {
        @State private var isPresented = true
        let task: HomeTask
        
        var body: some View {
            FullTaskInfoView(
                isPresented: $isPresented,
                task: task
            )
            .onAppear {
            }
        }
    }
    
    return PreviewWrapper(task: testTask)
}
