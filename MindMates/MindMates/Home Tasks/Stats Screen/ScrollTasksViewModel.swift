//
//  ScrollTasksViewModel.swift
//  MindMates
//
//  Created by Анастасия on 23.07.2025.
//

import Foundation

class ScrollTasksViewModel : ObservableObject {
    private let databaseService = HomeTaskDatabaseService()
        @Published var tasks: [HomeTask] = []
        @Published var isLoading = false
    
        @Published var error: Error?
        @Published var errorMessage = ""
        @Published var showErrorAlert = false
    
        var isMockMode = false
    
        convenience init(mockTasks: [HomeTask] = [], isLoading: Bool = false) {
            self.init()
            self.tasks = mockTasks
            self.isLoading = isLoading
            self.isMockMode = !mockTasks.isEmpty
        }

        func fetchTasks(userId: String, userRole: String) {
            guard !isMockMode else { return }
            
            isLoading = true
            databaseService.fetchTasks(for: userId, userRole: userRole) { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch result {
                    case .success(let tasks):
                        self?.tasks = tasks
                    case .failure(let error):
                        self?.error = error
                        self?.errorMessage = error.localizedDescription
                        self?.showErrorAlert = true
                    }
                }
            }
        }
}
