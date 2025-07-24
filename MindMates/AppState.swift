//
//  AppState.swift
//  MindMates
//
//  Created by Азалина Файзуллина on 23.07.2025.
//
import SwiftUI  // Этот импорт обязателен!
import Combine  
class AppState: ObservableObject {
    @AppStorage("isAuthenticated") var isAuthenticated = false
    @AppStorage("userEmail") var userEmail: String = ""
    @AppStorage("userName") var userName: String = ""
    @AppStorage("userRole") var userRole: String = ""
}
