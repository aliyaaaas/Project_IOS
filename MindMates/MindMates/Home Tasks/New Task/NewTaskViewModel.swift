//
//  NewTaskViewModel.swift
//  MindMates
//
//  Created by Анастасия on 19.07.2025.
//

import Foundation
import FirebaseAuth

class NewTaskViewModel : ObservableObject {
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
            
        Auth.auth().fetchSignInMethods(forEmail: studentEmail) { methods, error in
            if let error = error {
                completion(.failure(error))
                return
            }
                
            guard let methods = methods, !methods.isEmpty else {
                completion(.failure(NSError(domain: "UserNotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "Пользователь с таким email не найден"])))
                return
            }
                
            Auth.auth().signIn(withEmail: studentEmail, password: "dummyPassword") { result, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                    
                guard let studentId = result?.user.uid else {
                    completion(.failure(NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Не удалось получить ID ученика"])))
                    return
                }

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
            }
        }
    }
}
