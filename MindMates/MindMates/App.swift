//
//  AppDelegate.swift
//  MindMates
//
//  Created by Анастасия on 19.07.2025.
//

import SwiftUI
import Firebase

@main
struct MindMatesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authViewModel = AuthViewModel()
        
        init() {

        }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainContentView()
                    .environmentObject(authViewModel) 
            }
        }
    }
}

struct MainContentView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    var body: some View {
        if authViewModel.isAuthenticated {
            TabView {
                ProfileScreen()
                    .tabItem { Text("Профиль") }
            }
        } else {
            AuthView()
        }
    }
}


// План.
// 1. Сверстать экран настроек
// 2. Объединить проект
// 3. Настроить Firebase

/*
Firebase DataStorage || FireStorage
 
users (collection)
├── userId_1 (document)
│   ├── name: "Иван"
│   ├── role: "String"
│   ├── role: "имя"
│   ├── почта: "String"
│   └── email: "ivan@example.com"

// Ребятам
classes (collection)
├── classId_1 (document)
│   ├── title: "Математика"
│   ├── type: "future" / "past"
│   ├── date: Timestamp
│   ├── studentId
│   ├── tutorId
│   └── notes: ...

tasks (collection)
├── taskId_1 (document)
│   ├── title: "Домашка №3"
│   ├── assignedTo: studentId
│   ├── assignedBy: tutorId
│   ├── status: "новое" / "в процессе" / "проверено"
│   └── dueDate: Timestamp

class DataViewModel { || AuthViewModel
 
 private var db = Firestore.firestore()

 init() {
     fetchUserData()
 }

 func fetchUserData() {
     db.collection("users").document(uid).getDocument { snapshot, error in
         if let data = snapshot?.data() {
             self.userEmail = data["email"] as? String ?? ""
             self.displayName = data["displayName"] as? String ?? ""
         }
     }
 }

 func signOut() {
     do {
         try Auth.auth().signOut()
     } catch {
         print("Ошибка при выходе: \(error.localizedDescription)")
     }
 }

 func updateDisplayName(newName: String) {
     guard let uid = Auth.auth().currentUser?.uid else { return }
     db.collection("users").document(uid).updateData([
         "displayName": newName
     ]) { error in
         if let error = error {
             print("Ошибка обновления: \(error)")
         } else {
             self.displayName = newName
         }
     }
 }
 
*/
 
struct SettingsView: View {
    var body: some View {
        VStack {
            Image("logo1")
                .resizable()
                .frame(width: 70, height: 70)
        }
        .background(Color.red)
        .padding(.vertical)
    }
}
