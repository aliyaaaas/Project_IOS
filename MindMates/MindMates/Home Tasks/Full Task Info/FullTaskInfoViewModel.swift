//
//  FullTaskInfoViewModel.swift
//  MindMates
//
//  Created by Анастасия on 20.07.2025.
//

import Foundation

protocol HomeTaskDatabaseServiceProtocol {
    func updateTask(_ task: HomeTask, completion: @escaping (Result<Void, Error>) -> Void)
}

extension HomeTaskDatabaseService: HomeTaskDatabaseServiceProtocol {}

class FullTaskInfoViewModel: ObservableObject {
    @Published var task: HomeTask
    @Published var attachedDocuments: [URL] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let taskService: HomeTaskDatabaseServiceProtocol
    
    init(task: HomeTask, taskService: HomeTaskDatabaseServiceProtocol = HomeTaskDatabaseService()) {
        self.task = task
        self.taskService = taskService
        self.loadAttachedDocuments()
    }
    
    private func loadAttachedDocuments() {
        attachedDocuments = task.files?.compactMap { URL(string: $0) } ?? []
    }
    
    func sendTask(updatedTask: HomeTask, completion: @escaping (Bool) -> Void) {
        isLoading = true
        errorMessage = nil
        
        taskService.updateTask(updatedTask) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success:
                    self?.task = updatedTask
                    self?.loadAttachedDocuments()
                    completion(true)
                case .failure(let error):
                    self?.errorMessage = "Ошибка: \(error.localizedDescription)"
                    completion(false)
                }
            }
        }
    }
}
