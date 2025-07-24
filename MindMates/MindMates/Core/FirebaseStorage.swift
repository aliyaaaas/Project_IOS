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
        let uid = user.uid
        let userData: [String: Any] = [
            "uid": user.uid,
            "email": user.email,
            "displayName": user.email,
            "createdAt": FieldValue.serverTimestamp(),
            "role": role.rawValue
        ]
        db.collection("users").document("userInformation").setData(userData)
    }
    
    func getUserRole() async -> Role {
        do {
            let document = try await db.collection("users").document("userInformation").getDocument()
            guard let roleString = document.data()?["role"] as? String else {
                fatalError("Role not found")
            }
            return Role(rawValue: roleString)!
        } catch {
            fatalError("Error getting role: \(error)")
        }
    }
}
