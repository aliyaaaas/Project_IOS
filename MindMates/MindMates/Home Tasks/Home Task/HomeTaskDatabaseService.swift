//
//  HomeTaskDatabaseService.swift
//  MindMates
//
//  Created by Анастасия on 19.07.2025.
//

import FirebaseFirestore

class HomeTaskDatabaseService {
    private let db = Firestore.firestore()
    private let collectionName = "homeTasks"
    
    // Метод для добавления нового домашнего задания
    func addHomeTask(_ task: HomeTask, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let ref = try db.collection(collectionName).addDocument(from: task)
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    // Метод для изменения статуса домашнего задания
    func changeStatus(taskId: String, newStatus: TaskStatus, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(collectionName).document(taskId).updateData(["status": newStatus.rawValue]) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
    }
    
    // Метод для обновления всех данных задания
    func updateTask(_ task: HomeTask, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let taskId = task.id else {
            completion(.failure(NSError(domain: "MissingTaskID", code: 400)))
            return
        }
        
        do {
            try db.collection(collectionName).document(taskId).setData(from: task) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch let error {
            completion(.failure(error))
        }
    }
    
    // Метод для получения домашнего задания по айди
    func getTaskById(taskId: String, completion: @escaping (Result<HomeTask, Error>) -> Void) {
        db.collection(collectionName).document(taskId).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                if let task = try document?.data(as: HomeTask.self) {
                    completion(.success(task))
                } else {
                    completion(.failure(NSError(domain: "TaskNotFound", code: 404)))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // Подписка на изменения статуса задания
    func observeTaskStatus(taskId: String, completion: @escaping (Result<TaskStatus, Error>) -> Void) -> ListenerRegistration {
        return db.collection(collectionName)
            .document(taskId)
            .addSnapshotListener { document, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let statusString = document?.get("status") as? String,
                      let status = TaskStatus(rawValue: statusString) else {
                    completion(.failure(NSError(domain: "InvalidStatus", code: 400)))
                    return
                }
                
                completion(.success(status))
            }
    }
    
    // Подписка на обновление домашних заданий
    func observeStudentTasks(studentId: String, completion: @escaping (Result<[HomeTask], Error>) -> Void) -> ListenerRegistration {
        return db.collection(collectionName)
            .whereField("studentId", isEqualTo: studentId)
            .order(by: "deadline", descending: false)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                    
                let tasks = snapshot?.documents.compactMap { document in
                    try? document.data(as: HomeTask.self)
                } ?? []
                    
                completion(.success(tasks))
            }
    }
    
    // Метод для получения списка задач в зависимости от роли пользователя
    func fetchTasks(for userId: String, userRole: String, completion: @escaping (Result<[HomeTask], Error>) -> Void) {
        let query: Query
        
        switch userRole {
        case "student":
            query = db.collection(collectionName)
                .whereField("studentId", isEqualTo: userId)
                .order(by: "deadline", descending: false)
                
        default: // case "teacher":
            query = db.collection(collectionName)
                .whereField("teacherId", isEqualTo: userId)
                .order(by: "deadline", descending: false)
        }
        
        query.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let tasks = snapshot?.documents.compactMap { document in
                try? document.data(as: HomeTask.self)
            } ?? []
            
            completion(.success(tasks))
        }
    }
}
