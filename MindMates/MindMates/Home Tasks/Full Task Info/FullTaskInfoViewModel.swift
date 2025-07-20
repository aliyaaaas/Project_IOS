//
//  FullTaskInfoViewModel.swift
//  MindMates
//
//  Created by Анастасия on 20.07.2025.
//

import Foundation

class FullTaskInfoViewModel : ObservableObject {
    @Published var isPresented: Bool
    @Published var task: HomeTask
    @Published var taskStatus: TaskStatus
    @Published var attachedDocuments: [URL] = []
        
    private let taskService = HomeTaskDatabaseService()
        
    init(isPresented: Bool, task: HomeTask) {
        self.isPresented = isPresented
        self.task = task
        self.taskStatus = task.status
    }
        
    func sendTask(updatedTask: HomeTask) {
        taskService.updateTask(updatedTask) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.isPresented = false
                    self?.taskStatus = .onCheck
                case .failure(let error):
                    print("Ошибка при отправке задания: \(error.localizedDescription)")
                }
            }
        }
    }
}
