//
//  AuthService.swift
//  MindMates
//
//  Created by Азалина Файзуллина on 23.07.2025.
//

import FirebaseAuth

class AuthService: ObservableObject {
    @Published var currentUser: User? // Текущий пользователь
    
    // Инициализация с отслеживанием состояния входа
    init() {
        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            self?.currentUser = user
        }
    }
    
    // Вход по email и паролю
    func login(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            completion(true, nil)
        }
    }
    
    // Регистрация нового пользователя
    func register(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            completion(true, nil)
        }
    }
    
    // Выход
    func logout() {
        try? Auth.auth().signOut()
    }
}
