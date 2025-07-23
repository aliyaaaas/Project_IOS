//
//  ClassDatabaseService.swift
//  MindMates
//
//  Created by BATIK on 23.07.2025.
//

import Foundation
import FirebaseFirestore

class ClassDatabaseService {
    private let db = Firestore.firestore()
    private let collectionName = "classes"
    
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
