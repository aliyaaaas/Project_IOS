//
//  FullTaskInfoViewModel.swift
//  MindMates
//
//  Created by Анастасия on 20.07.2025.
//

import Foundation

// 1. Добавляем протокол для сервиса
protocol HomeTaskDatabaseServiceProtocol {
    func updateTask(_ task: HomeTask, completion: @escaping (Result<Void, Error>) -> Void)
}

// 2. Делаем ваш сервис соответствующим протоколу
extension HomeTaskDatabaseService: HomeTaskDatabaseServiceProtocol {}

class FullTaskInfoViewModel: ObservableObject {
    @Published var isPresented: Bool
    @Published var task: HomeTask
    @Published var taskStatus: TaskStatus
    @Published var attachedDocuments: [URL] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let taskService: HomeTaskDatabaseServiceProtocol
    
    // 3. Исправляем инициализатор
    init(isPresented: Bool,
         task: HomeTask,
         taskService: HomeTaskDatabaseServiceProtocol = HomeTaskDatabaseService()) {
        self.isPresented = isPresented
        self.task = task
        self.taskStatus = task.status
        self.taskService = taskService
        self.loadAttachedDocuments()
    }
    
    private func loadAttachedDocuments() {
        // 4. Безопасно разворачиваем task.files
        guard let files = task.files else { return }
        self.attachedDocuments = files.compactMap {
            guard let url = URL(string: $0) else {
                print("Invalid URL string: \($0)")
                return nil
            }
            return url
        }
    }
    
    func sendTask(updatedTask: HomeTask) {
        isLoading = true
        errorMessage = nil
        
        // 5. Явно указываем тип результата
        taskService.updateTask(updatedTask) { [weak self] (result: Result<Void, Error>) in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success:
                    self?.isPresented = false
                    self?.task = updatedTask
                    self?.taskStatus = updatedTask.status
                    // 6. Безопасно разворачиваем files
                    if let files = updatedTask.files {
                        self?.attachedDocuments = files.compactMap(URL.init)
                    }
                    
                case .failure(let error):
                    self?.errorMessage = "Ошибка при отправке задания: \(error.localizedDescription)"
                    print(self?.errorMessage ?? "")
                }
            }
        }
    }
    
    func addDocument(_ url: URL) {
        attachedDocuments.append(url)
    }
    
    func removeDocument(at index: Int) {
        attachedDocuments.remove(at: index)
    }
}
