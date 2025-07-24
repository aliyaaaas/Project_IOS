//
//  ClassDatabaseService.swift
//  MindMates
//
//  Created by BATIK on 23.07.2025.
//

import Foundation
import FirebaseFirestore

// ClassDatabaseService.swift
// MindMates

import Foundation
import FirebaseFirestore

class ClassDatabaseService {
    private let db = Firestore.firestore()
    private let collectionName = "classes"
    
    // MARK: - Добавление нового занятия
    func addClass(_ lesson: ClassModel, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let ref = try db.collection(collectionName).addDocument(from: lesson)
            print("Занятие добавлено с ID: \(ref.documentID)")
            completion(.success(()))
        } catch let error {
            print("Ошибка при добавлении занятия: \(error)")
            completion(.failure(error))
        }
    }
    
    // MARK: - Обновление статуса
    func changeStatus(classId: String, newStatus: ClassStatus, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(collectionName).document(classId).updateData(["status": newStatus.rawValue]) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
    }
    
    // MARK: - Полное обновление занятия
    func updateClass(_ lesson: ClassModel, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let classId = lesson.id else {
            completion(.failure(NSError(
                domain: "MissingClassID",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey: "ID занятия не найден"]
            )))
            return
        }
        
        do {
            try db.collection(collectionName).document(classId).setData(from: lesson) { error in
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
    
    // MARK: - Получение занятий
    func fetchClasses(for userId: String, userRole: String, completion: @escaping (Result<[ClassModel], Error>) -> Void) {
        let collection = db.collection(collectionName)
        let query: Query
        
        if userRole == "teacher" {
            query = collection.whereField("teacherId", isEqualTo: userId)
        } else {
            query = collection.whereField("studentId", isEqualTo: userId)
        }
        
        query.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                let classes = try snapshot?.documents.compactMap { doc in
                    try doc.data(as: ClassModel.self)
                } ?? []
                completion(.success(classes))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
