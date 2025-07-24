//
//  ScrollClassesViewModel.swift
//  MindMates
//
//  Created by BATIK on 23.07.2025.
//

import Foundation

class ScrollClassesViewModel: ObservableObject {
    private let databaseService = ClassDatabaseService()
    
    @Published var classes: [ClassModel] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var errorMessage = ""
    @Published var showErrorAlert = false
    
    var isMockMode = false
    
    convenience init(mockClasses: [ClassModel] = [], isLoading: Bool = false) {
        self.init()
        self.classes = mockClasses
        self.isLoading = isLoading
        self.isMockMode = !mockClasses.isEmpty
    }

    func fetchClasses(userId: String, userRole: String) {
        guard !isMockMode else { return }
        
        isLoading = true
        databaseService.fetchClasses(for: userId, userRole: userRole) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let classes):
                    self?.classes = classes
                case .failure(let error):
                    self?.error = error
                    self?.errorMessage = error.localizedDescription
                    self?.showErrorAlert = true
                }
            }
        }
    }
}
