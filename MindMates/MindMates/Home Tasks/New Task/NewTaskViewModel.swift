//
//  NewTaskViewModel.swift
//  MindMates
//
//  Created by Анастасия on 19.07.2025.
//

import Foundation
import FirebaseAuth

class NewTaskViewModel: ObservableObject {
    private let databaseService = HomeTaskDatabaseService()
    
    func createNewTask(
        subject: String,
        studentEmail: String,
        description: String,
        deadline: Date,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Пользователь не авторизован"])))
            return
        }
        
        if currentUser.email == studentEmail {
            completion(.failure(NSError(domain: "ValidationError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Нельзя создать задание для самого себя"])))
            return
        }
        
        Auth.auth().fetchSignInMethods(forEmail: studentEmail) { methods, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let methods = methods, !methods.isEmpty else {
                completion(.failure(NSError(domain: "UserNotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "Пользователь с таким email не найден"])))
                return
            }
            
            self.getUserIdByEmail(studentEmail) { result in
                switch result {
                case .success(let studentId):
                    let newTask = HomeTask(
                        subject: subject,
                        teacherId: currentUser.uid,
                        studentId: studentId,
                        description: description,
                        deadline: deadline,
                        status: .notStarted
                    )
                    
                    self.databaseService.addHomeTask(newTask) { result in
                        completion(result)
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func getUserIdByEmail(_ email: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().fetchSignInMethods(forEmail: email) { methods, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard methods != nil else {
                completion(.failure(NSError(domain: "UserNotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "Пользователь с таким email не найден"])))
                return
            }
            
            completion(.failure(NSError(domain: "NotImplemented", code: 501, userInfo: [NSLocalizedDescriptionKey: "Функционал получения UID по email не реализован"])))
        }
    }
}
