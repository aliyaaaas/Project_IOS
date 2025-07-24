//
//  FirebaseStorage.swift
//  MindMates
//
//  Created by Азалина Файзуллина on 24.07.2025.
//

import Firebase
import FirebaseAuth
import FirebaseStorage

class FirebaseStorage {
    static let shared = FirebaseStorage()
    
    private var db = Firestore.firestore()
    
    private init() {}
    
    func saveUser(_ user: User, role: Role = .student) {
        let userData: [String: Any] = [
            "uid": user.uid,
            "email": user.email ?? "",
            "displayName": user.displayName ?? user.email ?? "Нет имени",
            "createdAt": FieldValue.serverTimestamp(),
            "role": role.rawValue
        ]
        db.collection("users").document(user.uid).setData(userData) 
    }
    
    func getUserRole(uid: String) async throws -> Role {
        let document = try await db.collection("users").document(uid).getDocument()
        guard let data = document.data(),
                let roleString = data["role"] as? String,
                let role = Role(rawValue: roleString) else {
            throw NSError(domain: "Role not found", code: 0)
        }
        return role
    }
    
    func getUserName(uid: String, completion: @escaping (String?) -> Void) {
        db.collection("users").document(uid).getDocument { document, error in
            if let document = document, document.exists {
                let name = document.data()?["displayName"] as? String
                completion(name)
            } else {
                completion(nil)
            }
        }
    }
}
