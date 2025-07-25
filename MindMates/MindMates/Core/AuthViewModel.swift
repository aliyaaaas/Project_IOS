//
//  Untitled.swift
//  MindMates
//
//  Created by Азалина Файзуллина on 24.07.2025.
//

import Firebase
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var isAuthenticated: Bool
    @Published var error: String = ""
    
    private let authService = AuthService()
    
    init() {
        self.user = authService.currentUser
        self.isAuthenticated = authService.currentUser != nil
    }
    
    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        authService.login(email: email, password: password) { success, errorMessage in
            DispatchQueue.main.async {
                if success {
                    self.user = self.authService.currentUser
                    self.isAuthenticated = true
                    self.error = ""
                    completion(true)
                } else {
                    self.error = errorMessage ?? "Неизвестная ошибка"
                    completion(false)
                }
            }
        }
    }
    
    func singUp(email: String, password: String, completion: @escaping (Bool) -> Void) {
        authService.register(email: email, password: password) { success, errorMessage in
            DispatchQueue.main.async {
                if success {
                    self.user = self.authService.currentUser
                    self.isAuthenticated = true
                    self.error = ""
                    FirebaseStorage.shared.saveUser(self.user!)
                    completion(true)
                } else {
                    self.error = errorMessage ?? "Неизвестная ошибка"
                    completion(false)
                }
            }
        }
    }
    
    func signOut() {
        authService.logout()
        user = nil
        isAuthenticated = false
    }
}
