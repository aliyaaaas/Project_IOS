//
//  NewTaskViewModel.swift
//  MindMates
//
//  Created by Анастасия on 19.07.2025.
//

import Foundation
import FirebaseAuth

class NewTaskViewModel {
    private let databaseService = HomeTaskDatabaseService()
    
    func createNewTask(
        subject : String,
        studentEmail : String,
        description : String,
        deadline : Date,
        completion : @escaping (Result<Void, Error>) -> Void
    ) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Пользователь не авторизован"])))
            return
        }
        
        let newTask = HomeTask(
            subject: subject,
            teacherId: currentUser.uid,
            studentId: "", // логику обработки email -> id надо реализовать
            description: description,
            deadline: deadline,
            status: .notStarted
            )
        
        databaseService.addHomeTask(newTask) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
