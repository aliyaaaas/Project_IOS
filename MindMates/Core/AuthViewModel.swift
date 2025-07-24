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
    
    init() {
        let user = Auth.auth().currentUser
        self.user = user
        self.isAuthenticated = user != nil
        
        // Убрать!!!
        signOut()
    }
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error {
                    let errorString = error.localizedDescription
                    self.error = errorString
                }
                if let user = result?.user {
                    self.user = user
                    self.isAuthenticated = true
                }
            }
        }
    }
    
    func singUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error {
                    let errorString = error.localizedDescription
                    self.error = errorString
                }
                if let user = result?.user {
                    self.user = user
                    self.isAuthenticated = true
                    
                    FirebaseStorage.shared.saveUser(user)
                }
            }
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        user = nil
        isAuthenticated = false
    }
}
