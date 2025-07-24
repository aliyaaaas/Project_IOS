//
//  ProfileScreenViewModel.swift
//  MindMates
//
//  Created by Азалина Файзуллина on 24.07.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

enum Role: String {
    case student = "Студент"
    case teacher = "Преподаватель"
}

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var displayName: String = ""
    @Published var email: String = ""
    @Published var role: Role?
    
    private var uid: String? {
        Auth.auth().currentUser?.uid
    }

    private var db = Firestore.firestore()

    init() {
        self.fetchCurrentUser()
    }

    func fetchCurrentUser() {
        guard let uid else { return }

        db.collection("users").document("userInformation").getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                self.displayName = data?["displayName"] as? String ?? "Нет имени"
                self.email = data?["email"] as? String ?? "Нет почты"
                self.role = Role(rawValue: data?["role"] as? String ?? "Ученик" ) ?? .student
            } else {
                print("Документ не найден: \(error?.localizedDescription ?? "нет ошибки")")
            }
        }
    }
    
    func updateName(_ displayName: String) {
        guard let uid else { return }
        
        db.collection("users").document(uid).updateData([
            "displayName": displayName
        ]) { error in
            if let error = error {
                print("Ошибка при обновлении имени: \(error.localizedDescription)")
            } else {
                print("Имя успешно обновлено")
                self.displayName = displayName
            }
        }
    }
    
    func updateRole(_ role: Role) {
        guard let uid else { return }
        
        db.collection("users").document(uid).updateData([
            "role": role.rawValue
        ]) { error in
            if let error = error {
                print("Ошибка при обновлении имени: \(error.localizedDescription)")
            } else {
            }
            return
        }
        print("Имя успешно обновлено")
        self.role = role
    }
    
    func updateEmail(_ email: String) {
        guard let uid else { return }
        
        db.collection("users").document(uid).updateData([
            "email": email
        ]) { error in
            if let error = error {
                print("Ошибка при обновлении имени: \(error.localizedDescription)")
            } else {
                print("Имя успешно обновлено")
                self.email = email
            }
        }
    }
    func logout() {
        
    }
}

